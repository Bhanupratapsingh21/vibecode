# You can use most Debian-based base images
FROM node:21-slim

# Install curl
RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY compile_page.sh /compile_page.sh
RUN chmod +x /compile_page.sh

WORKDIR /home/user/nextjs-app

# Create Next app
RUN npx --yes create-next-app@15.3.3 . --yes

# Install shadcn
RUN npx --yes shadcn@2.6.3 init --yes -b neutral --force
RUN npx --yes shadcn@2.6.3 add --all --yes

# Ensure lib/utils.ts exists
RUN mkdir -p lib && \
    echo 'export function cn(...inputs: any[]) { return inputs.filter(Boolean).join(" ") }' > lib/utils.ts

# Remove problematic tw-animate-css import
RUN sed -i '/tw-animate-css/d' app/globals.css

# 🔥 Verify build works inside template
RUN npm install
RUN npm run build

# Move the Nextjs app to the home directory
RUN mv /home/user/nextjs-app/* /home/user/ && rm -rf /home/user/nextjs-app