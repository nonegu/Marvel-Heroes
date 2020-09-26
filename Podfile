# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Marvel Heroes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marvel Heroes
  pod 'Kingfisher', '~> 5.0'
  pod 'RealmSwift'
  
  post_install do |installer|
       installer.pods_project.targets.each do |target|
             target.build_configurations.each do |config|
                   config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
             end
       end
   end

  target 'Marvel HeroesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Marvel HeroesUITests' do
    # Pods for testing
  end

end
