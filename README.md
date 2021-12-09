# ReversePemCert

A PowerShell script to reverse the order of the certificate chain in a PEM certificate file (while preserving any private keys).

## Usage
To run this script, simply pass in the path to a certificate file as the only argument, for example: 

`./ReversePemCert.ps1 MyCertificate.pem`

By default the updated certificate will be written as output, so optionally redirect the output to a new certificate file:

`./ReversePemCert.ps1 MyCertificate.PEM > MyFixedCertificate.pem`

## Purpose

This was created to fix an issue with CD/CI pipelines caused by Azure KeyVault exporting App Service Certificates in a non-standard order (with the root certificate first, instead of last).  NGINX is unable to use certificates in this order, so I needed an easy way to reverse the certificate I was getting from KeyVault.
