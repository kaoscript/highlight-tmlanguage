var fs = require('fs');
var path = require('path');
var plist = require('plist');
var yaml = require('js-yaml');

function readYaml(file) {
    return yaml.safeLoad(fs.readFileSync(file, 'utf8'));
}

function writePlistFile(grammar, file) {
    fs.writeFileSync(file, plist.build(grammar), 'utf8');
}

writePlistFile(readYaml('./kaoscript.tmLanguage.yaml'), './kaoscript.tmLanguage');