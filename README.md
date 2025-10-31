# Weather App - Flutter Web App

Ứng dụng thời tiết được xây dựng bằng Flutter và có thể nhúng vào web app.

## Tính năng

- 🔍 Tìm kiếm thời tiết theo tên thành phố
- 🌡️ Hiển thị nhiệt độ hiện tại và cảm nhận
- 💧 Thông tin độ ẩm, tốc độ gió, áp suất
- 📱 Responsive design, hoạt động tốt trên mobile và desktop
- 🌐 Hỗ trợ Flutter Web để nhúng vào web app

## Yêu cầu

- Flutter SDK (sử dụng FVM để quản lý version)
- Dart SDK
- Node.js (để chạy web server nếu cần)

## Cài đặt

### 1. Cài đặt FVM (nếu chưa có)

```bash
dart pub global activate fvm
fvm install stable
fvm use stable
```

### 2. Cài đặt dependencies

```bash
fvm flutter pub get
```

### 3. Lấy API Key từ OpenWeatherMap

1. Đăng ký tài khoản miễn phí tại: https://openweathermap.org/api
2. Lấy API key từ dashboard
3. Mở file `lib/weather_screen.dart` và thay thế `_apiKey` bằng API key của bạn:

```dart
final String _apiKey = 'your_api_key_here';
```

## Chạy ứng dụng

### Chạy trên Web

```bash
# Build Flutter Web app
fvm flutter build web

# Chạy web server (sử dụng một trong các cách sau):

# Cách 1: Sử dụng Python
cd build/web
python3 -m http.server 8000

# Cách 2: Sử dụng Node.js (http-server)
npx http-server build/web -p 8000

# Cách 3: Sử dụng Flutter dev server
fvm flutter run -d chrome
```

### Nhúng vào Web App

Sau khi build, bạn có 2 cách để nhúng vào web app:

#### Cách 1: Sử dụng iframe (đơn giản)

```html
<iframe 
    src="path/to/build/web/index.html"
    width="100%" 
    height="600px"
    frameborder="0">
</iframe>
```

#### Cách 2: Sử dụng web_wrapper

1. Copy thư mục `build/web` vào `web_wrapper/flutter_app/`
2. Mở file `web_wrapper/index.html` trong browser

## Cấu trúc dự án

```
demo_weather/
├── lib/
│   ├── main.dart           # Entry point
│   ├── weather_screen.dart  # UI chính
│   └── weather_model.dart  # Data model
├── web/
│   ├── index.html          # Flutter Web entry
│   └── manifest.json       # PWA manifest
├── web_wrapper/
│   └── index.html          # Web app wrapper để nhúng Flutter
├── pubspec.yaml            # Dependencies
└── README.md
```

## API sử dụng

Ứng dụng sử dụng OpenWeatherMap API:
- Endpoint: `https://api.openweathermap.org/data/2.5/weather`
- Free tier: 1,000 calls/day, 60 calls/minute

## Development

### Chạy ở chế độ development

```bash
fvm flutter run -d chrome
```

### Build cho production

```bash
fvm flutter build web --release
```

### Kiểm tra lỗi

```bash
fvm flutter analyze
```

## Deploy lên GitHub Pages

### Tự động với GitHub Actions (Khuyên dùng)

1. Push code lên GitHub repository
2. Vào **Settings** → **Pages** trong repository
3. Chọn source: **GitHub Actions** hoặc branch **gh-pages**
4. Workflow sẽ tự động build và deploy khi push code

Có 2 workflow files:
- `deploy-simple.yml` - Sử dụng peaceiris/actions-gh-pages (Đơn giản hơn)
- `deploy.yml` - Sử dụng official GitHub Pages actions

Xem chi tiết trong [DEPLOY.md](./DEPLOY.md)

### Deploy thủ công

```bash
# Build với base-href là tên repository
fvm flutter build web --release --base-href "/demo_weather/"

# Deploy lên gh-pages branch
cd build/web
# Sử dụng gh-pages CLI hoặc git commands (xem DEPLOY.md)
```

App sẽ có tại: `https://[username].github.io/[repository-name]/`

## Lưu ý

- API key cần được bảo mật, không commit vào git
- Có thể sử dụng environment variables để quản lý API key
- Để tối ưu performance, có thể cache dữ liệu thời tiết
- Khi deploy lên GitHub Pages, đảm bảo `--base-href` khớp với tên repository

## License

MIT License

