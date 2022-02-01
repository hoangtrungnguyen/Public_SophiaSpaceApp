
# Ứng dụng Small Habits
## Chạy release
```sh
flutter run --release
```

## Chạy debug
Kết nối điện thoại và máy tính vào cùng một wifi
Chạy debug cần khởi động Firebase emulators trước:

```sh
firebase init emulator
```

#### Thay đổi thành ip local ở các file:
    - network_security_config.xml
    - firebase_config.dart
**Xem thêm tại:**
    https://firebase.google.com/docs/emulator-suite/install_and_configure#startup
    https://stackoverflow.com/questions/45940861/android-8-cleartext-http-traffic-not-permitted