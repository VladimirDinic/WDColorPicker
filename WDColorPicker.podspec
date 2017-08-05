Pod::Spec.new do |s|

s.platform = :ios
s.name             = "WDColorPicker"
s.version          = "0.0.6"
s.summary          = "WDColorPicker is a simple lightweight component for displaying color picker inside iOS apps."

s.description      = <<-DESC
This library enables you to include color picker very easy in your iOS app, and to use it in two basic modes: as interface component, or as a pop up.
DESC

s.homepage         = "https://github.com/VladimirDinic/WDColorPicker"
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { "Vladimir Dinic" => "vladimir88dev@gmail.com" }
s.source           = { :git => "https://github.com/VladimirDinic/WDColorPicker.git", :tag => "#{s.version}"}

s.ios.deployment_target = "10.0"
s.source_files = "WDColorPicker/WDColorPicker/WDColorPickerView/*"

end
