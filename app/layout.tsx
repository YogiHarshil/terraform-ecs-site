import './globals.css'

export const metadata = {
  title: 'Next.js ECS Terraform',
  description: 'Next.js deployed on AWS ECS with Terraform',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
} 