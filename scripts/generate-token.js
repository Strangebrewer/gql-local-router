const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env.local') });

const jwt = require('jsonwebtoken');

const privateKey = process.env.JWT_PRIVATE_KEY;
const userId = process.env.TEST_USER_ID || 'test-user-1';

if (!privateKey) {
  console.error('JWT_PRIVATE_KEY not found in .env.local');
  process.exit(1);
}

const token = jwt.sign(
  { sub: userId },
  privateKey,
  { algorithm: 'RS256', expiresIn: '24h' },
);

console.log('\nBearer token (valid 24h):\n');
console.log(token);
console.log('');
