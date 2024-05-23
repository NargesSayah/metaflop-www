Here is a step by step guide to set-up Metaflop in developer mode on Mac OS.
I'm setting it up in VSCode's Terminal.

1. Navigate to your workspace.    
2. **Install Homebrew:** If you haven't installed Homebrew yet, you can do so by running the following command in the Terminal:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. **Install Ruby:** Metaflop requires Ruby version 1.9.2 or higher. You can use rbenv or rvm to manage Ruby versions.
   ```bash
   brew install rbenv
   rbenv init
   echo 'eval "$(rbenv init -)"' >> ~/.zshrc
   source ~/.zshrc
   rbenv install 3.0.0
   rbenv global 3.0.0
   ```
   Note: Version ```3.0.0``` is opted as a recent one. Feel free to check out other versions.
5. Install Bundler and Ruby Dependencies:
   ```bash
   gem install bundler
   ```
6. Other prerequisites:
   - **TexLive and Metapost:**
     ```bash
     brew install --cask mactex
     ```
     Note: Make sure your device is not low on space, otherwise you should see an error.
     It might also ask for your password at some point.
   - **FontForge:**
     ```bash
     brew install fontforge
     ```
     Note: You can create a small Python script to test if the FontForge module works. It should contain:
     ```Python
     import fontforge
     font = fontforge.font()
     print("FontForge module is working!")
     ```
     Save this as test_fontforge.py and run it:
     ```bash
     python3 test_fontforge.py
     ```
     If this script runs without errors and prints "FontForge module is working!", then you have successfully set up FontForge for use in Python.

     In case you get an error indicating: ```ModuleNotFoundError: No module named 'fontforge'``` it means even though FontForge is installed on your system, the Python bindings necessary to use FontForge within Python scripts are not properly configured or recognized.
     To resolve this you can manually install Python bindings:
     ```bash
     git clone https://github.com/fontforge/fontforge.git
     cd fontforge
     ```
     Make sure all dependencies are installed, especially Python-related ones:
     ```bash
     brew install cmake ninja pkg-config python-setuptools
     ```
     Then we want to compile and install FontForge with Python support using `cmake`,
     but before that you need to create a separate build directory.
     This is because FontForge's configuration strictly prohibits in-source builds. 
     ```bash
     mkdir build
     cd build
     ```
     Now go ahead and do `cmake`:
     ```bash
     cmake -GNinja -DENABLE_PYTHON_SCRIPTING=ON -DENABLE_GUI=OFF -DPYTHON_EXECUTABLE=$(which python3) ..
     ```

     Here I got `Freetype Library Not Found` so make sure Freetype is installed and can be found or linked.
     ```bash
     brew install freetype
     ```
     And try again:
     ```bash
     cd build
     rm -rf *  # To delete all files in the directory
     cmake -GNinja -DENABLE_PYTHON_SCRIPTING=ON -DENABLE_GUI=OFF -DPYTHON_EXECUTABLE=$(which python3) ..
     ```

     If CMake still cannot find certain libraries (like `Freetype`), you may need to provide hints about where to find them:
     ```bash
     cmake -GNinja -DENABLE_PYTHON_SCRIPTING=ON -DENABLE_GUI=OFF -DPYTHON_EXECUTABLE=$(which python3) -                  
     DFREETYPE_LIBRARY=/path/to/freetype/lib -DFREETYPE_INCLUDE_DIRS=/path/to/freetype/include ..
     ```
     This is how you can find the `/path/to/freetype/lib` and `/path/to/freetype/include`:
     - First, ensure it is installed:
       ```bash
       brew list freetype
       ```
     - If installed, you can get details on where it's installed using:
       ```bash
       brew info freetype
       ```
       This might give an output like this:    
       `
       freetype: stable 2.10.4 (bottled), HEAD
       A software library to render fonts
       https://www.freetype.org/
       /usr/local/Cellar/freetype/2.10.4 (60 files, 2.5MB) *
       Poured from bottle on 2021-03-15 at 17:18:19
       From: https://github.com/Homebrew/homebrew-core/blob/master/Formula/freetype.rb    
       `

       From this, the relevant paths would typically be:     
       `Library Path: /usr/local/Cellar/freetype/2.10.4/lib`      
       `Include Path: /usr/local/Cellar/freetype/2.10.4/include`

     - Now the cmake command might look like:
       ```bash
       cmake -GNinja \
       -DENABLE_PYTHON_SCRIPTING=ON \
       -DENABLE_GUI=OFF \
       -DPYTHON_EXECUTABLE=$(which python3) \
       -DFREETYPE_LIBRARY=/usr/local/Cellar/freetype/2.13.2/lib/libfreetype.6.dylib \
       -DFREETYPE_INCLUDE_DIRS=/usr/local/Cellar/freetype/2.13.2/include/freetype2 \
       ..
       ```

     If you still got errors like `distutils Module Not Found Error`:
     ```bash
     pip install setuptools
     ```
     And re-run:
     ```bash
     cd build
     rm -rf *
     cmake -GNinja \
     -DENABLE_PYTHON_SCRIPTING=ON \
     -DENABLE_GUI=OFF \
     -DPYTHON_EXECUTABLE=$(which python3) \
     -DFREETYPE_LIBRARY=/usr/local/Cellar/freetype/2.13.2/lib/libfreetype.6.dylib \
     -DFREETYPE_INCLUDE_DIRS=/usr/local/Cellar/freetype/2.13.2/include/freetype2 ../fontforge
     ```

   - **Build the Project:**
     Execute the build process with Ninja by running the following command in the same directory where you ran the CMake configuration:
     ```bash
     ninja
     ```
   - If you plan to install FontForge on your system (which may or may not be necessary depending on your needs), you can do so using the following command:
     ```bash
     sudo ninja install
     ```
   - **LCDF Typetools:**
     ```bash
     brew install lcdf-typetools
     ```
     Note: This will probably ask you to link  this version, so:
     ```bash
     brew link lcdf-typetools
     ```
     I got an error indicating it could not symlink since some files share the same name between lcdf-typetools and texlive.
     So:
     ```bash
     brew link --overwrite lcdf-typetools --dry-run
     ```
   - **sfnt2woff:**
     ```bash
     xcode-select --install
     git clone https://github.com/bramstein/sfnt2woff.git
     cd sfnt2woff
     make
     sudo mv sfnt2woff /usr/local/bin/
     ```
     Note:
     Since sfnt2woff is not available through Homebrew.
   - **ttf2eot:**
     ```bash
     brew install ttf2eot
     ```
   - **T1 Utilities:**
     ```bash
     brew install t1utils
     ```
   - **Python and Libraries:**
     ```bash
     brew install python
     ```
     Make sure you're in the Fontforge directory:
     ```bash
     cd fontforge
     brew install cmake pkg-config cairo pango libpng jpeg giflib libtiff
     pip install argparse
     ```
6. MySQL & Metaflop installation
```bash
brew install mysql
brew services start mysql
mysql -u root -p
CREATE DATABASE metaflop_development;
```
Choose a location where you want to clone the Metaflop repository. 
```bash
cd ~/../..
mkdir Metaflop
cd Metaflop
```

Clone the Metaflop Repository:
```bash
git clone https://github.com/NargesSayah/metaflop-www.git
```     

Once the repository is cloned, navigate to the cloned directory and set up the database configuration.
```bash
cd metaflop-www
cp config/db.yml.sample config/db.yml
```
Open config/db.yml in your editor and update it with your MySQL username and password.      

Make sure you are in the Metaflop project directory and have installed the required Ruby gems.
```bash
gem install bundler -v 2.4.22
bundle install
```

Here I got some errors:
   `Gem::Ext::BuildError: ERROR: Failed to build gem native extension.`    
and   
   `An error occurred while installing mysql2 (0.5.5), and Bundler cannot continue.`     
   ```Make sure that `gem install mysql2 -v '0.5.5' --source 'https://rubygems.org/'` succeeds before bundling.```    

- The error you're encountering while trying to install the mysql2 gem is related to compatibility issues with MySQL and its libraries. To fix this, try ensuring that the correct version of MySQL and its headers are installed and correctly linked.
   ```bash
   brew install mysql-client
   brew link --force mysql-client
   brew link --force openssl@1.1
   ```    
- Set the environment variables to ensure the mysql2 gem uses the correct paths for MySQL and OpenSSL:
   ```bash
   export PATH="/usr/local/opt/mysql-client/bin:$PATH"
   export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
   export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
   ```

- Try to install the mysql2 gem manually with the correct options:
   ```bash
   gem install mysql2 -v '0.5.5' -- --with-ldflags="-L/usr/local/opt/openssl@1.1/lib" --with-cppflags="-I/usr/local/opt/openssl@1.1/include"
   ```

- Again you might get an error like this: ```An error occurred while installing mysql2 (0.5.5), and Bundler cannot continue.
Make sure that `gem install mysql2 -v '0.5.5' --source 'https://rubygems.org/'` succeeds before bundling.``` which means there is some version mismatches between the MySQL client library and the gem. Try:
   ```bash
   brew uninstall mysql-client
   brew install mysql@5.7
   brew link --force mysql@5.7
   export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
   export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
   export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
   gem install mysql2 -v '0.5.5' -- --with-mysql-config=/usr/local/opt/mysql@5.7/bin/mysql_config
   ```

- Now you should be able to do:
   ```bash
   gem install bundler -v 2.4.22
   bundle install
   ```

7. Run the Application:
```bash
gem install rack
rackup
```
Did you get ```cannot load such file -- sinatra/asset_pipeline (LoadError)```?      
`sinatra/asset_pipeline` gem not being found could be due to the gem not being installed correctly or not being included in the Gemfile.
- Ensure sinatra-asset-pipeline is in the Gemfile:
  ```bash
  gem 'sinatra-asset-pipeline', github: 'koffeinfrei/sinatra-asset-pipeline'
  ```
- Re-run bundle install. This should be the last time!
  ```bash
  bundle install
  ```
- Verify that the gem is installed by checking the bundler's list of installed gems:
  ```bash
  bundle show sinatra-asset-pipeline
  ```
- Re-run the application:
  ```bash
  rackup
  ```

8. WEBrick (the default Ruby web server) must be running on port 9292.    
   Open your preferred web browser and go to http://localhost:9292     
   Enjoy!


   
