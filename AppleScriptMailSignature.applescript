tell application "Mail"
	set signatureName to "HTML Signature"
	set signatureContent to "<p>This is my HTML signature.</p>" -- Replace with your HTML code
	try
		set oldSignature to signature signatureName
		delete oldSignature
	end try
	set newSignature to make new signature with properties {name:signatureName, content:signatureContent}
	set default signature to newSignature
end tell
