COMMA_PATH = (...):match("(.-)[^%.]+$") .. 'comma.'
return require(COMMA_PATH .. 'autorun')
