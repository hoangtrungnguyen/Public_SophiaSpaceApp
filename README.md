
# Ứng dụng Small Habits

## Cấu hình cho nhà phát triển mới

### Quyền vào các công cụ phát triển
- [] Github
- [] Firebase

### Phiên bản các SDK
- [] Flutter: **2.8.1**
- [] Dart: **2.15.1**



## Chạy debug

Kết nối điện thoại và máy tính vào cùng một wifi
Chạy debug cần khởi động Firebase emulators trước:

#### Cấu hình lần đầu
```sh
firebase init emulator
```

#### Khởi động giả lập trước mỗi lần chạy debug
```sh
firebase emulators:start
```

#### Thay đổi thành ip local ở các file:
- [] /android/src/debug/res/xml/network_security_config.xml
- [] /lib/configure/firebase_config.dart

##### Kiểm tra ip local
```
ipconfig
```

### Chạy debug:
```
flutter run
```

**Xem thêm tại:**
[link](https://firebase.google.com/docs/emulator-suite/install_and_configure#startup)
[link](https://stackoverflow.com/questions/45940861/android-8-cleartext-http-traffic-not-permitted)


## Chạy profile
Bản build dùng để đo hiệu suất của ứng dụng
```
flutter run --profile
```

## Chạy release
Key cho App Store lấy từ máy của chủ sở hữu: Hoàng Trung Nguyên

Thông tin liên hệ
- Facebook: [link](https://www.facebook.com/hoang.tr.nguyen.1810/)
- Email: hoangtrungnguyen18102000@gmail.com hoặc nguyencua1810@gmail.com

```sh
flutter run --release
```

## Build app bundle
Checklist
- []: Kiểm tra TODO
- []: Clean code
- []: Tạo mã phiển bản mới

```
flutter build appbundle --release
```



## Đường dẫn hữu dụng có thể cần

**Export dữ liệu production về firebase emulators**
- [link](https://github.com/firebase/firebase-tools/issues/1167)

**Lab Github action**
- [link](https://lab.github.com/githubtraining/github-actions:-hello-world)

**Kill using port**
- [link](https://stackoverflow.com/questions/60996172/unable-to-connect-to-firebase-emulator-suite-with-exec)