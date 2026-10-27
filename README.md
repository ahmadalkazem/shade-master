# Shade Master

Android flutter application to help dentist pick shades from a shade guide.

## How to use it

You need to take a photo with your phone that shows both the teeth and the shades approximate to each other, under the same lighting conditions, and as much as possible without glare.

Then using the application you should select the teeth, and select the shades, the application would tell you which shade is closest.

DEMO:
![Gif image](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExbnd5Y3cxcXNhbHRqc2Z2bTJieGVvcjZ1ZnAwMGRod2p2M2swcGY4aCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/A2ciVtQU9n0twS0Zxj/giphy.gif)

## Technical info

For technical information about the algorithm used please refer to the file `lib/analysis/analyze.dart`

## Development notes

- Builds with Flutter 3.47.8 and JDK 17 or newer; the Android SDK and NDK versions come from Flutter. CI builds the APK on every push: `.github/workflows/android-build.yml`.
- Arabic notes on the current code and the plan for the dental lab order card:
  - [docs/prep-report.md](docs/prep-report.md): audit, license questions, build results and open issues
  - [docs/how-it-works.md](docs/how-it-works.md): screens, the shade matching algorithm and known bugs
  - [docs/roadmap.md](docs/roadmap.md): Arabic UI, lab order card and PDF export

## License MIT
