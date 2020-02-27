# Shift Blockchain Explorer

Shift Explorer version 1.5.0 works in conjunction with the Shift Core API. It uses Redis for caching data and Freegeoip to parse IP geo-location data.

[![Build Status](https://travis-ci.org/mswezey23/shift-explorer-prototype.svg?branch=development)](https://travis-ci.org/mswezey23/shift-explorer-prototype)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

## Prerequisites

These programs and resources are required to install and run Shift Explorer

- Nodejs v10.13.X or higher (<https://nodejs.org/>) -- Nodejs serves as the underlying engine for code execution.

  ```
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -y nodejs
  ```

- Redis (<http://redis.io>) -- Redis is used for caching parsed exchange data.

  `sudo apt-get install -y redis-server`

- Freegeoip (<https://github.com/fiorix/freegeoip>) -- Freegeoip is used by the Network Monitor for IP address geo-location.

  ```
  wget https://github.com/fiorix/freegeoip/releases/download/v3.1.5/freegeoip-3.1.5-linux-amd64.tar.gz
  tar -zxf freegeoip-3.1.5-linux-amd64.tar.gz
  ln -s freegeoip-3.1.5-linux-amd64 freegeoip
  nohup ./freegeoip/freegeoip > ./freegeoip/freegeoip.log 2>&1 &
  ```

// TODO: remove grunt?
- Grunt.js (<http://gruntjs.com/>) -- Grunt is used to run eslint and unit tests.

  `sudo npm install -g grunt`

- PM2 (https://github.com/Unitech/pm2) -- PM2 manages the node process for Shift Explorer and handles log rotation (Highly Recommended)

  `sudo npm install -g pm2`
  
- PM2-logrotate (https://github.com/pm2-hive/pm2-logrotate) -- Manages PM2 logs

  ```
  pm2 install pm2-logrotate
  pm2 set pm2-logrotate:max_size 100M
  ```

- Git (<https://github.com/git/git>) -- Used for cloning and updating Shift Explorer

  `sudo apt-get install -y git`

- Tool chain components -- Used for compiling dependencies

  `sudo apt-get install -y python build-essential automake autoconf libtool`

## Installation Steps

Clone the Shift Explorer Repository:

```
git clone https://github.com/mswezey23/shift-explorer-prototype.git
cd shift-explorer
yarn install
```

## Build Steps

#### Frontend
 The frontend is using Webpack to create core bundles for Shift Explorer.  
 
 For having a watcher to generate bundles continuously for all the changes of the code, Run the following command:

`yarn start`
 
 And for generating the minified bundles in production environment run:
 
`yarn build:prd`

 If you want to add a meta tag with name and content defined (For example to verify your ownership to Google analytics) run:
 
 `SERVICE_NAME='your service name' CLIENT_ID='you client id' npm run build`



#### Market Watcher
 Candlestick data needs to be initialized prior to starting Shift Explorer. During runtime candlestick data is updated automatically.

To build candlestick data for each exchange run:

`grunt candles:build`

To update candlestick data manually run after initialization:

`grunt candles:update`

## Configuration

The default `config.js` file contains all of the configuration settings for Shift Explorer. These options can be modified according to comments included in configuration file.

#### Top Accounts

To enable Top Accounts functionality, edit your Shift Client config.json _(not the explorer)_:

```
{
    "port": 8000,
    "address": "0.0.0.0",
    "version": "0.5.0",
    "minVersion": "~0.5.0",
    "fileLogLevel": "info",
    "logFileName": "logs/shift.log",
    "consoleLogLevel": "info",
    "trustProxy": false,
    "topAccounts": false, <--- This line needs to be changed to read true
```

After the change is made the Shift Client will need to be restarted. (Example):

`bash /PATH_TO_SHIFT_DIR/shift.sh reload`

## Managing Shift Explorer

To test that Shift Explorer is configured correctly, run the following command:

`node app.js`

Open: <http://localhost:6040>, or if its running on a remote system, switch `localhost` for the external IP Address of the machine.

Once the process is verified as running correctly, `CTRL+C` and start the process with `PM2`. This will fork the process into the background and automatically recover the process if it fails.

`pm2 start pm2-explorer.json`

After the process is started its runtime status and log location can be found by issuing this statement:

`pm2 list`

To stop Explorer after it has been started with `PM2`, issue the following command:

`pm2 stop shift-explorer`

## Tests

Before running any tests, please ensure Shift Explorer and Shift Client are configured to run on the Shift Testnet.

Replace **config.js** with **config.test** file from the **test** directory:

`cp test/config.test ./config.js`

Replace the **config.json** for the Shift Client the corresponding file under the **test** directory:

`cp test/config_shift.json  /PATH_TO_SHIFT_DIR/config.json`

Then restart the Shift Client (example):

`pm2 restart /PATH_TO_SHIFT_DIR/app.js`

Launch Shift Explorer (runs on port 6040):

`pm2 start pm2-explorer.json`

Run the test suite:

`npm test`

Run individual tests:

```
npm test -- test/api/accounts.js
npm test -- test/api/transactions.js
```

## End-to-end Tests

### Setup for end-to-end tests:

Do all setup steps from "Test" section of this README

Make sure you have `wget` installed (it's used in `./e2e-test-setup.sh`). On Linux by default. On MacOS:
```
brew install wget
```

Setup protractor

```
./node_modules/protractor/bin/webdriver-manager update
```

### Run end-to-end test suite:

```
./e2e-test-setup.sh /PATH_TO_SHIFT_DIR
npm run e2e-test -s
```

### Run one end-to-end test feature file:

```
npm run e2e-test -s -- --specs=features/address.feature
```

## License

Copyright © 2017-2018 Shift

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](https://github.com/ShiftHQ/lisk-explorer/tree/master/LICENSE) along with this program.  If not, see <http://www.gnu.org/licenses/>.

***

This program also incorporates work previously released with lisk-explorer `1.1.0` (and earlier) versions under the [MIT License](https://opensource.org/licenses/MIT). To comply with the requirements of that license, the following permission notice, applicable to those parts of the code only, is included below:

Copyright © 2017-2018 Shift  
Copyright © 2016-2017 Lisk Foundation  
Copyright © 2015 Crypti

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
