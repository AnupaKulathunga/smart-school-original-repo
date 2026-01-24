<?php
/**
 * Generate a valid SSLK license key for Docker development environment.
 * This replicates the license validation logic from the Aes library.
 *
 * Usage: php generate_license.php <base_url>
 */

$base_url = isset($argv[1]) ? $argv[1] : 'http://localhost:8080/';

// Replicate Aes::validchk('encrypt', base_url)
$encrypt_method = "AES-256-CBC";
$secret_key = '4D617279206861642061206C6974746C65206C616D';
$secret_iv = '4F505A5B5C5D5E5F60616A6B6C6D6E6F7A7D7';

$key = hash('sha256', $secret_key);
$iv = substr(hash('sha256', $secret_iv), 0, 16);

$encrypted = openssl_encrypt($base_url, $encrypt_method, $key, 0, $iv);
$valid_string = base64_encode($encrypted);

// Generate SSLK in the format XXXXXX-XXXXXX-XXXXXX-{valid_string}
$prefix = strtoupper(substr(md5($base_url), 0, 6)) . '-' .
          strtoupper(substr(md5($base_url . 'salt1'), 0, 6)) . '-' .
          strtoupper(substr(md5($base_url . 'salt2'), 0, 6));

$sslk = $prefix . '-' . $valid_string;

// Write to license.php
$license_path = '/var/www/html/smart_school_src/application/config/license.php';

$content = "<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

\$config['envato_market_purchase_code'] = 'docker-dev';
\$config['envato_market_username'] = 'docker';
\$config['SSLK'] = '{$sslk}';
\$config['app_ver'] = 0;
";

if (file_put_contents($license_path, $content)) {
    echo "License generated successfully for: {$base_url}\n";
    echo "SSLK: {$sslk}\n";
} else {
    echo "Error: Could not write license file\n";
    exit(1);
}
