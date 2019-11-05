Pod::Spec.new do |spec|


  spec.name         = "XiangHongUIKit"
  spec.version      = "0.0.2"
  spec.summary      = "XiangHongUIKit，界面ui集合。"
  
  spec.description  = <<-DESC
                XiangHongUIKit是界面UI集合，里面存放不同类型的ui控件。
                   DESC

  spec.homepage     = "https://github.com/xh1130485186/XHUIKit.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "xianghong" => "1130485186@qq.com" }

  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/xh1130485186/XHUIKit.git", :tag => spec.version }

  spec.resource  = "UIComponent/xhkit.ui.bundle"

  spec.requires_arc = true
  
  spec.dependency 'XiangHongKit'
  spec.source_files = 'XHUIKitDefines.h'
  # spec.public_header_files = 'XHUIKitDefines.h'
  spec.subspec 'XHContainer' do |subpec|
    subpec.dependency = 'XiangHongUIKit'
    subpec.source_files = 'UIComponent/XHContainer/*.{h,m}'
  end
 
end
