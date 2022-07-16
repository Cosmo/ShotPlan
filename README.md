# ShotPlan (WIP)

A command line tool that calls your Xcode Test Plan and creates screenshots of your app automatically.

## Installation

### [Mint](https://github.com/yonaskolb/mint)

```sh
mint install Cosmo/ShotPlan@main
```

## Configuration

Change to your Xcode project and run the `shotplan init` command to create a new configuration file.
Don't forget to replace the placeholders `YOUR_SCHEME` and `YOUR_TESTPLAN`.

```sh
shotplan init -s YOUR_SCHEME -t YOUR_TESTPLAN
```

This will create a file called `ShotPlan.json` that looks like this:

```json
{
  "scheme" : "YOUR_SCHEME",
  "devices" : [
    {
      "homeStyle" : "indicator",
      "displaySize" : "6.5",
      "simulatorName" : "iPhone 11 Pro Max"
    },
    {
      "homeStyle" : "button",
      "displaySize" : "5.5",
      "simulatorName" : "iPhone 8 Plus"
    },
    {
      "homeStyle" : "indicator",
      "displaySize" : "12.9",
      "simulatorName" : "iPad Pro (12.9-inch) (5th generation)"
    }
  ],
  "testPlan" : "YOUR_TESTPLAN"
}
```

## Usage

Run the following command:

```sh
shotplan run
```

ShotPlan will create a `Screenshots` directory in your project.
