# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bulb' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftLint'
  pod 'Toast-Swift', '~> 5.0.1'

  # Firebase SDK
  pod 'FirebaseAuth'
  pod 'GoogleSignIn'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseStorageUI'
  pod 'SDWebImage'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseUI'

  def testing_pods
      pod 'Quick'
      pod 'Nimble'
  end

  abstract_target 'Tests' do
    target "BulbTests"
    testing_pods
  end
end
