import express from 'express';
import Product from '../models/Product.js';
import { protectRoute, admin } from '../middleware/authMiddleware.js';
import asyncHandler from 'express-async-handler';
import User from '../models/User.js';

const productRoutes = express.Router();

// Get paginated products or all products
const getProducts = asyncHandler(async (req, res) => {
  const page = parseInt(req.params.page) || 1;
  const perPage = parseInt(req.params.perPage) || 10;

  const totalProducts = await Product.countDocuments();

  const products = await Product.find({})
    .skip((page - 1) * perPage)
    .limit(perPage);

  const totalPages = Math.ceil(totalProducts / perPage);

  res.json({ products, pagination: { currentPage: page, totalPages } });
});

// Get single product by id
const getProduct = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (product) {
    res.json(product);
  } else {
    res.status(404);
    throw new Error('Product not found');
  }
});

// Create product review
const createProductReview = asyncHandler(async (req, res) => {
  const { rating, comment, userId, title } = req.body;

  const product = await Product.findById(req.params.id);
  const user = await User.findById(userId);

  if (!product) {
    res.status(404);
    throw new Error('Product not found');
  }

  const alreadyReviewed = product.reviews.find(
    (review) => review.user.toString() === user._id.toString()
  );

  if (alreadyReviewed) {
    res.status(400);
    throw new Error('Product already reviewed');
  }

  const review = {
    name: user.name,
    rating: Number(rating),
    comment,
    title,
    user: user._id,
  };

  product.reviews.push(review);
  product.numberOfReviews = product.reviews.length;
  product.rating =
    product.reviews.reduce((acc, item) => item.rating + acc, 0) / product.reviews.length;

  await product.save();

  res.status(201).json({ message: 'Review has been saved.' });
});

// Create new product (admin only)
const createNewProduct = asyncHandler(async (req, res) => {
  const {
    brand,
    name,
    category,
    stock,
    price,
    images,
    productIsNew,
    description,
    subtitle,
    stripeId,
  } = req.body;

  const newProduct = await Product.create({
    brand,
    name,
    category,
    subtitle,
    description,
    stock,
    price,
    images,
    productIsNew,
    stripeId,
  });

  if (newProduct) {
    const products = await Product.find({});
    res.json(products);
  } else {
    res.status(400);
    throw new Error('Product could not be uploaded');
  }
});

// Update product (admin only)
const updateProduct = asyncHandler(async (req, res) => {
  const {
    brand,
    name,
    category,
    stock,
    price,
    id,
    productIsNew,
    description,
    subtitle,
    stripeId,
    imageOne,
    imageTwo,
  } = req.body;

  const product = await Product.findById(id);

  if (!product) {
    res.status(404);
    throw new Error('Product not found');
  }

  product.name = name;
  product.subtitle = subtitle;
  product.price = price;
  product.description = description;
  product.brand = brand;
  product.category = category;
  product.stock = stock;
  product.productIsNew = productIsNew;
  product.stripeId = stripeId;
  product.images = [imageOne, imageTwo];

  await product.save();

  const products = await Product.find({});
  res.json(products);
});

// Remove a product review (admin only)
const removeProductReview = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.productId);

  if (!product) {
    res.status(404);
    throw new Error('Product not found');
  }

  product.reviews = product.reviews.filter(
    (review) => review._id.toString() !== req.params.reviewId
  );

  product.numberOfReviews = product.reviews.length;

  if (product.numberOfReviews > 0) {
    product.rating = product.reviews.reduce((acc, item) => item.rating + acc, 0) / product.reviews.length;
  } else {
    product.rating = 5;
  }

  await product.save();

  const products = await Product.find({});
  res.json({ products, pagination: {} });
});

// Delete product (admin only)
const deleteProduct = asyncHandler(async (req, res) => {
  const product = await Product.findByIdAndDelete(req.params.id);

  if (product) {
    res.json(product);
  } else {
    res.status(404);
    throw new Error('Product not found');
  }
});

// Routes
productRoutes.route('/:page/:perPage').get(getProducts);
productRoutes.route('/').get(getProducts);
productRoutes.route('/:id').get(getProduct);
productRoutes.route('/reviews/:id').post(protectRoute, createProductReview);
productRoutes.route('/:id').delete(protectRoute, admin, deleteProduct);
productRoutes.route('/').put(protectRoute, admin, updateProduct);
productRoutes.route('/:productId/:reviewId').put(protectRoute, admin, removeProductReview);
productRoutes.route('/').post(protectRoute, admin, createNewProduct);

export default productRoutes;
