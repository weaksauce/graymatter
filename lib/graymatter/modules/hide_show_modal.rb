module GM
  # A modal overlay.
  module HideShowModal
    class << self
      attr_accessor :modal_view
      attr_accessor :modal_is_visible
    end

    # call this method from your controller's `viewDidLoad` method
    def prepareHideShowModal
      unless HideShowModalModule.modal_view
        HideShowModalModule.modal_view = UIView.alloc.initWithFrame(App.window.bounds)
        HideShowModalModule.modal_view.backgroundColor = :black.uicolor(0.5)
        spinner = UIActivityIndicatorView.large
        spinner.center = [modal.bounds.width / 2, modal.bounds.height / 2]
        spinner.startAnimating
        HideShowModalModule.modal_view << spinner
      end
      unless HideShowModalModule.modal_view.isDescendantOfView(App.window)
        App.window << HideShowModalModule.modal_view
      end

      HideShowModalModule.modal_view.alpha = 0.0
      HideShowModalModule.modal_is_visible = false
    end

    def showModal
      App.window.bringSubviewToFront(HideShowModalModule.modal_view)
      unless HideShowModalModule.modal_is_visible
        FuncTools.CFMain {
          HideShowModalModule.modal_view.alpha = 0.0
          HideShowModalModule.modal_view.show
          HideShowModalModule.modal_view.fade_in
        }
        HideShowModalModule.modal_is_visible = true
      end
    end

    def hideModal
      FuncTools.CFMain {
        HideShowModalModule.modal_view.fade_out
      }
      HideShowModalModule.modal_is_visible = false
    end

  end
end
