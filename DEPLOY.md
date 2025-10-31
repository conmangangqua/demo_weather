# Hướng dẫn Deploy lên GitHub Pages

## Cách 1: Sử dụng GitHub Actions (Tự động - Khuyên dùng)

### Bước 1: Chuẩn bị Repository
1. Push code lên GitHub repository
2. Đảm bảo branch chính là `main` hoặc `master`

### Bước 2: Bật GitHub Pages
1. Vào repository trên GitHub
2. Click vào **Settings** → **Pages**
3. Ở phần **Source**, chọn:
   - **Source**: Deploy from a branch
   - **Branch**: `gh-pages` → `/ (root)`
   - Hoặc chọn **GitHub Actions** làm source

### Bước 3: Chọn Workflow
Có 2 workflow file đã được tạo:

#### Option A: `deploy-simple.yml` (Đơn giản hơn - Khuyên dùng)
- Sử dụng `peaceiris/actions-gh-pages`
- Tự động deploy khi push lên main/master
- Không cần cấu hình thêm

#### Option B: `deploy.yml` (Official GitHub Pages)
- Sử dụng official GitHub Pages actions
- Cần bật GitHub Pages trong Settings → Pages
- Chọn "GitHub Actions" làm source

### Bước 4: Push code và đợi deploy
```bash
git add .
git commit -m "Setup GitHub Pages"
git push origin main
```

Workflow sẽ tự động:
1. Build Flutter web app
2. Deploy lên branch `gh-pages`
3. App sẽ có tại: `https://[username].github.io/[repository-name]/`

## Cách 2: Deploy thủ công

### Bước 1: Build web app
```bash
fvm flutter build web --release --base-href "/demo_weather/"
```
(Lưu ý: Thay `demo_weather` bằng tên repository của bạn)

### Bước 2: Deploy lên GitHub Pages
```bash
# Cài đặt gh-pages CLI (nếu chưa có)
npm install -g gh-pages

# Deploy
cd build/web
gh-pages -d . -r https://github.com/[username]/[repository-name].git
```

Hoặc sử dụng git:
```bash
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin https://github.com/[username]/[repository-name].git
git push -u origin gh-pages
```

### Bước 3: Bật GitHub Pages
1. Vào Settings → Pages
2. Chọn branch `gh-pages` và folder `/ (root)`
3. Save

## Lưu ý quan trọng

1. **Base URL**: Khi build, đảm bảo `--base-href` khớp với tên repository
   - Nếu repo là `demo_weather`, dùng: `--base-href "/demo_weather/"`
   - Nếu repo là username.github.io, dùng: `--base-href "/"`

2. **API Key**: API key của bạn sẽ hiển thị trong code (client-side)
   - Nên sử dụng environment variables trong GitHub Actions
   - Hoặc tạo file `.env` và không commit vào git

3. **Custom Domain**: Nếu có custom domain, thêm file `CNAME` vào `build/web/`

## Troubleshooting

### App không load được
- Kiểm tra base-href trong build command
- Kiểm tra console để xem lỗi cụ thể
- Đảm bảo file `index.html` có trong thư mục root

### Workflow không chạy
- Kiểm tra Actions tab để xem logs
- Đảm bảo branch name là `main` hoặc `master`
- Kiểm tra file workflow có đúng syntax không

### Lỗi 404
- Đảm bảo base-href đúng với repository name
- Kiểm tra GitHub Pages đã được bật chưa

