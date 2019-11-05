Pod::Spec.new do |spec|


  spec.name         = "XiangHongUIKit"
  spec.version      = "0.0.1"
  spec.summary      = "XiangHongUIKit，界面ui集合。"
  
  spec.description  = <<-DESC
                XiangHongUIKit是界面UI集合，里面存放不同类型的ui控件。
                   DESC

  spec.homepage     = "https://github.com/xh1130485186/XHKitUI.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "xianghong" => "1130485186@qq.com" }

  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/xh1130485186/XHKitUI.git", :tag => spec.version }

  spec.resource  = "UIComponent/xhkit.ui.bundle"

  spec.requires_arc = true
  
  spec.source_files = 'UIComponent/*.{h,m}'
  
  spec.subspec 'XHContainer' do |subpec|
  
    spec.subspec 'XHDatePicker' do |ssubpec|
      ssubpec.dependency "XiangHongKit"
      ssubpec.source_files = 'UIComponent/XHContainer/XHDatePicker/*.{h,m}'
    end
    spec.subspec 'XHSecondMenu' do |ssubpec|
      ssubpec.dependency "XiangHongKit"
      ssubpec.source_files = 'UIComponent/XHContainer/XHSecondMenu/*.{h,m}'
    end
    spec.subspec 'XHPickerView' do |ssubpec|
      ssubpec.dependency "XiangHongKit/Tools/XHContainer"
      ssubpec.source_files = 'UIComponent/XHContainer/XHPickerView/*.{h,m}'
    end
    spec.subspec 'XHPopupMenu' do |ssubpec|
      ssubpec.dependency "XiangHongKit"
      ssubpec.source_files = 'UIComponent/XHContainer/XHPopupMenu/*.{h,m}'
    end
    
  end
  
  spec.subspec 'UILabel' do |subpec|
    subpec.source_files = 'UIComponent/UILabel/*.{h,m}'
  end
  
  spec.subspec 'XHTextView' do |subpec|
    subpec.source_files = 'UIComponent/XHTextView/*.{h,m}'
  end
  
  spec.subspec 'XHHorizontalMenu' do |subpec|
    subpec.dependency "XiangHongKit/Extensions"
    subpec.source_files = 'UIComponent/XHHorizontalMenu/*.{h,m}'
  end
  
  spec.subspec 'XHProgressView' do |subpec|
    subpec.source_files = 'UIComponent/XHProgressView/*.{h,m}'
  end
  
  spec.subspec 'Theme' do |subpec|
    subpec.dependency "XiangHongKit/Common"
    subpec.source_files = 'UIComponent/Theme/*.{h,m}'
  end
  
  spec.subspec 'XHChart' do |subpec|
    subpec.source_files = 'UIComponent/XHChart/*.{h,m}'
  end
  
  spec.subspec 'XHAlertController' do |subpec|
     subpec.dependency "XiangHongKit/Extensions/UIApplication"
    subpec.source_files = 'UIComponent/XHAlertController/*.{h,m}'
  end
  
  spec.subspec 'XHButton' do |subpec|
    subpec.source_files = 'UIComponent/XHButton/*.{h,m}'
  end
  
  #spec.subspec 'XHDropDownMenu' do |subpec|
   # subpec.dependency "XiangHongKit"
    #subpec.dependency 'XiangHongUIKit/UIComponent/XHButton'
    #subpec.source_files = 'UIComponent/XHDropDownMenu/*.{h,m}'
  #end
  
  spec.dependency "XiangHongKit"
  spec.dependency "XHLoading"

end