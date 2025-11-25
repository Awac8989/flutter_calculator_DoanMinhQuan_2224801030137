# Flutter Calculator - LAB3

**Đoàn Minh Quân - 2224801030137**

## 📋 Mô tả dự án

Ứng dụng máy tính Flutter với giao diện Samsung Galaxy và tính năng lưu phép tính. Dự án được phát triển cho môn học lập trình di động, tập trung vào thiết kế responsive và quản lý trạng thái hiệu quả.

## ✨ Tính năng chính

### 🧮 Chế độ máy tính
- **Basic Mode**: Các phép tính cơ bản (+, -, ×, ÷)
- **Scientific Mode**: Hàm lượng giác, logarit, căn bậc 2, lũy thừa
- **Programmer Mode**: Chuyển đổi hệ số (Hex, Dec, Oct, Bin), phép toán logic

### 🎨 Giao diện người dùng
- **Samsung Galaxy UI Style**: Thiết kế hiện đại, màu sắc tương tự Galaxy
- **Responsive Design**: Hỗ trợ cả portrait và landscape
- **Dark/Light Theme**: Chuyển đổi theme linh hoạt
- **Smooth Animations**: Hiệu ứng chuyển tiếp mượt mà

### 💾 Quản lý dữ liệu
- **Saved Calculations**: Lưu và quản lý phép tính
- **History**: Lịch sử tính toán tự động
- **Memory Functions**: M+, M-, MR, MC
- **Data Persistence**: Lưu trữ dữ liệu bền vững với SharedPreferences

### 🔧 Tính năng nâng cao
- **Search Functionality**: Tìm kiếm trong phép tính đã lưu
- **Favorite System**: Đánh dấu phép tính quan trọng
- **Edit Capabilities**: Chỉnh sửa tên và mô tả phép tính
- **Error Handling**: Xử lý lỗi toán học và input validation

## 🏗️ Kiến trúc dự án

```
lib/
├── main.dart                      # Entry point
├── models/                        # Data models
│   ├── angle_mode.dart           # Góc độ/radian
│   ├── calculation_history.dart  # Lịch sử tính toán
│   ├── calculator_mode.dart      # Chế độ máy tính
│   ├── calculator_settings.dart  # Cài đặt ứng dụng
│   ├── number_base.dart          # Hệ số (Hex, Dec, Oct, Bin)
│   └── saved_calculation.dart    # Phép tính đã lưu
├── providers/                     # State management
│   ├── calculator_provider.dart  # Logic tính toán chính
│   └── theme_provider.dart       # Quản lý theme
├── screens/                       # Màn hình chính
│   └── calculator_screen.dart    # Màn hình máy tính
├── services/                      # Services layer
│   └── storage_service.dart      # Lưu trữ dữ liệu
├── utils/                         # Utilities
│   └── constants.dart            # Constants và styles
└── widgets/                       # UI Components
    ├── button_grid.dart          # Lưới button
    ├── calculator_button.dart    # Button component
    ├── display_area.dart         # Vùng hiển thị
    ├── landscape_layout.dart     # Layout ngang
    ├── mode_selector.dart        # Chọn chế độ
    └── saved_calculations_view.dart # Quản lý phép tính đã lưu
```

## 🚀 Cài đặt và chạy

### Yêu cầu hệ thống
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio hoặc VS Code
- Android device/emulator (API 21+)

### Các bước cài đặt

1. **Clone repository**
```bash
git clone https://github.com/Awac8989/flutter_calculator_DoanMinhQuan_2224801030137.git
cd flutter_calculator_DoanMinhQuan_2224801030137
git checkout lab3
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

## 📱 Hướng dẫn sử dụng

### Tính toán cơ bản
1. Nhập số và phép toán
2. Nhấn `=` để tính kết quả
3. Sử dụng `C` để xóa, `CE` để xóa entry

### Lưu phép tính
1. Thực hiện phép tính
2. Nhấn biểu tượng bookmark trong AppBar
3. Nhập tên và mô tả (tùy chọn)
4. Nhấn "Save" để lưu

### Quản lý phép tính đã lưu
1. Nhấn biểu tượng bookmark để xem danh sách
2. Sử dụng search bar để tìm kiếm
3. Nhấn vào phép tính để load lại
4. Sử dụng menu để edit, favorite hoặc delete

### Chuyển chế độ
- **Basic**: Phép tính cơ bản
- **Scientific**: Hàm khoa học (sin, cos, tan, log, ln, √, x²)
- **Programmer**: Hệ số và phép logic (AND, OR, XOR, NOT)

## 🛠️ Công nghệ sử dụng

### Framework & Language
- **Flutter 3.0+**: UI framework
- **Dart 3.0+**: Programming language

### State Management
- **Provider Pattern**: Quản lý trạng thái reactive
- **ChangeNotifier**: Notify listeners khi state thay đổi

### Data Persistence
- **SharedPreferences**: Local storage
- **JSON Serialization**: Data format

### Architecture Pattern
- **MVVM**: Model-View-ViewModel pattern
- **Separation of Concerns**: Tách biệt logic và UI

## 🎯 Đặc điểm kỹ thuật

### Performance
- **Efficient State Management**: Chỉ rebuild widgets cần thiết
- **Optimized Animations**: Sử dụng AnimationController hợp lý
- **Memory Management**: Dispose resources đúng cách

### Security
- **Input Validation**: Validate user input
- **Error Boundaries**: Graceful error handling
- **Data Sanitization**: Clean data before storage

### UX/UI
- **Material Design 3**: Tuân thủ guidelines
- **Accessibility**: Support screen readers
- **Responsive**: Hoạt động tốt trên nhiều screen size

## 🧪 Testing

### Manual Testing
- ✅ Basic arithmetic operations
- ✅ Scientific functions
- ✅ Programmer mode operations
- ✅ Save/load calculations
- ✅ Theme switching
- ✅ Orientation changes
- ✅ Memory operations
- ✅ Error handling

### Test Cases
1. **Calculation Accuracy**: Verify math operations
2. **State Persistence**: Data survives app restart
3. **UI Responsiveness**: Smooth interactions
4. **Error Handling**: Graceful failure recovery

## 🚀 Future Enhancements

### Planned Features
- [ ] Cloud sync with Firebase
- [ ] Advanced scientific functions
- [ ] Unit converter
- [ ] Graph plotting
- [ ] Export calculations to PDF
- [ ] Voice input
- [ ] Widget support

### Performance Optimizations
- [ ] Lazy loading for history
- [ ] Image caching
- [ ] Background processing
- [ ] Memory optimization

## 📄 License

Dự án này được phát triển cho mục đích học tập tại trường Đại học.

## 👨‍💻 Tác giả

**Đoàn Minh Quân**
- MSSV: 2224801030137
- Email: [student-email]
- GitHub: [@Awac8989](https://github.com/Awac8989)

## 🤝 Đóng góp

Dự án này là bài tập cá nhân. Mọi góp ý xin liên hệ qua email hoặc tạo issue trên GitHub.

## 📚 Tài liệu tham khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)
- [Samsung Design Guidelines](https://developer.samsung.com/one-ui)

## 📸 Ảnh Chụp Màn Hình (Screenshots)

<img width="1626" height="1013" alt="Screenshot 2025-11-21 172054" src="https://github.com/user-attachments/assets/bcfca9cb-e714-4bfa-9cfe-7d249aa95ec0" />
