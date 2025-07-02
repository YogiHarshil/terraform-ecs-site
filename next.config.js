/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  compress: true,
  poweredByHeader: false,
  experimental: {
    outputFileTracingRoot: process.cwd(),
  },
}

module.exports = nextConfig 