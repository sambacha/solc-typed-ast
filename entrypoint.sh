#!/bin/bash
npm install
npm run transpile
chmod +x ./dist/bin/compile.js 
./dist/bin/compile.js --help 

