## 0.3.0 - 2024-10-11
#### Documentation
- using cog to enforce semver and conventional commits standards - (0278cf1) - pkleineb
- applied license correctlydocs: copyright - (25d9de0) - pkleineb
- updated readme with new default - (e3c96fa) - pkleineb
#### Features
- added exclude patterns to the scheme searching algorithm - (7eff1cd) - pkleineb
- reworked theme finding algorithm it now mostly finds the actual color scheme source files - (dd6e43b) - pkleineb
#### Style
- changed to snake_case - (68551ba) - pkleineb

- - -
## 0.5.0 - 2025-03-08
#### Bug Fixes
- **(loader)** on defautl colorscheme background of light colorschemes preview persisted outside of preview - (b6d9086) - pkleineb
#### Documentation
- added new default config to README - (169d1a3) - pkleineb
#### Features
- **(loader)** lazily loads colorschemes to preview - (9832910) - pkleineb
- **(persistent_theme)** added timeout to config and made persitent theme able to being turned off - (4512a72) - pkleineb
- **(window)** added scroll ability to picker window - (3373028) - pkleineb
- **(window)** added a preview window and buffer - (7e239a4) - pkleineb
#### Miscellaneous Chores
- **(defaults)** fixed typo - (d56b072) - pkleineb
- **(defaults)** changed defaults since I prefer a smaller window - (a500151) - pkleineb
- **(defaults)** added default text for preview - (bfc2782) - pkleineb
- **(loader)** beautified preview window, making it not change it's own border - (d947010) - pkleineb
- **(utils)** QOL for the preview text so the indentation is looking good - (7950aa0) - pkleineb
- **(window)** refactored some code might do some later but idk - (a82349d) - pkleineb

- - -

## 0.4.1 - 2024-10-18
#### Bug Fixes
- **(initialising)** 5 is too low of a timeout but increasing might make the themeadding less responsive >:[ - (f263184) - pkleineb
- **(search_bar)** fixed error that occured when instantly hitting a key after window creation would place that key at the first character in the line - (b796b53) - pkleineb

- - -

## 0.4.0 - 2024-10-12
#### Bug Fixes
- **(init)** when starting nvim devicons aren't colored without a wait - (6a24e08) - pkleineb
- selecting same scheme twice would make the scheme not unloadable - (bf973fa) - pkleineb
#### Documentation
- updated docs for newest feature - (cbb53fb) - pkleineb
- updated Changelog to version 0.3.0 - (ecf5b9d) - pkleineb
#### Features
- added keep colorscheme functionality - (04c546f) - pkleineb
#### Miscellaneous Chores
- **(version)** 0.4.1 - (552d9f1) - pkleineb

- - -

## 0.4.1 - 2024-10-12
#### Bug Fixes
- selecting same scheme twice would make the scheme not unloadable - (bf973fa) - pkleineb

- - -


## 0.2.0 - 2024-10-11
#### Bug Fixes
- goofy me - (3aa9a55) - pkleineb
- themepicker didnt run so now lets try again - (d0559f4) - pkleineb
- Fixed bug related that threw an error if you search for a non existend colorscheme - (a083241) - pkleineb
- Fixed a bug so that when at the end of the list of colorschemes you get send either to the bottom or top - (83ffe5a) - pkleineb
- New Command name for actual use - (489880b) - paul
#### Documentation
- updated License header - (7cbd0d6) - pkleineb
- added LICENSE - (66b8498) - pkleineb
- Some more info - (b888c7c) - pkleineb
- fixed up the readme - (3f07a44) - pkleineb
- Added more documentation - (5e6031b) - pkleineb
#### Features
- Added possiblity to add multiple theme dirs - (60ae50b) - pkleineb
- resetting highlight while searching - (c7474f2) - pkleineb
- implemented switching to theme under highlight - (1386784) - pkleineb
- added functionality for multiple modes and added keybinds for scrolling in PickerBuffer - (57e64e9) - pkleineb
- implemented fuzzy searching; next up selecting - (72303ac) - pkleineb
- added the facilities for a searchbar now have to work on getting text input and delete working correctly - (cb48cfd) - pkleineb
- added unloading of atleast lua based colorschemes - (aae57f6) - paul
#### Style
- added some custom highlighters and the possiblity to change the highlighters colors - (cf29d5a) - pkleineb
- implemented highlighting - (8dc6065) - pkleineb
- Added some styling to the window and the options to change those - (0bb7149) - pkleineb

- - -

## 0.1.0 - 2024-10-11
#### Bug Fixes
- implemented proper config passage - (6d6dfd7) - paul
#### Documentation
- Changed codeblocks in README to use lua highlighting - (0de6d59) - mattes
- Added README to start documentation - (c94e7b1) - paul
- setting config keybinds - (6b44210) - paul
#### Features
- **(defaults)** definig default configs - (a176ccb) - paul
- we can close the window with q now - (6a34a66) - paul
- main plug file - (a0f2b04) - paul
- creating window - (14afc21) - paul
- utility functionality - (ace16e5) - paul
- finding themes that are installed on $NVIMDATA path - (9540b82) - paul
- loading colortheme lazyly - (be4fd50) - paul
- added a setup function to the module that needed it and figured out how to use configs - (bc722ae) - paul
- heyyyyy i made some progress can now read all the themes that are in the nvim data folder, display them and centers the window in the middle - (20fbfc5) - paul
#### Tests
- dont need test it runs smoothly anyways - (f779d69) - paul
- implementing tests and some file structure - (4d9173e) - paul
- testing floating window creation - (ca2f9b9) - paul


