## Getting Started

This project uses Flutter SDK version 3.27.3.

You can run the project using [FVM](https://fvm.app/) with the following command:
```
fvm flutter run
```

Without FVM, use:
```
flutter run
```

You can check the Flutter version in the `/.fvmrc` file:

```
{
  "flutter": "3.27.3"
}
```


## Generating a Unique ID for Promotion Logic

Since each API call generates products randomly, To apply promotion logic for the same product, I generate a unique ID based on the format: `Section (Recommend/Latest) + ID + Name`. This helps track product promotions effectively.

## Configuring API Base URL for Local Development

If you have trouble fetching data from localhost, update the base URL in `lib/config/app_config.dart`:

- For Android Emulator: Replace `localhost` with `10.0.2.2`.
- For iOS Simulator: Replace `localhost` with `127.0.0.1`.
- Alternatively, use the actual host API URL.

For any issues, feel free to contact me at **p.ploypukdee@gmail.com**.