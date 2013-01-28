GrayMatter
==========

A collection of useful tools, by Colin T.A. Gray.  Depends on [SugarCube][].

module namespace: `GM`

[SugarCube]: https://github.com/rubymotion/sugarcube

GestureRecognizers
------------------

### GM::HorizontalPanGestureRecognizer
### GM::VerticalPanGestureRecognizer

These recognize a pan gesture in only one direction.  The default threshold is
`HorizontalPanGestureRecognizer::DefaultThreshold` (4), but can be changed with the
`threshold` attribute.

UIViews
-------

### GM::SetupView (module)

It infuriates me that there are two ways to setup a view: `initWithFrame` and
`awakeFromNib`.  There needs to be *one* place to put code for custom views.
`SetupView` provides that one place.

```ruby
class MyView < UIView
  include GM::SetupView

  def setup
    # this code will only be run once
  end
end
```

### GM::ForegroundColorView

Sometimes you need a background color that is part of your view hierarchy.  I
can't remember why **I** needed to, but this view does the trick.  Assign a
`color` attribute and it will fill a rect with that color.  Also supports a
`path` attribute, which is a `UIBezierPath` that clips the view.

Basically, you can draw a swath of color this way.

### GM::FabTabView

This is a very simple tab view.  It controls a list of controllers, which should
implement a `fab_tab_button` attribute (if you want to explicitly declare that
your controller is a FabTabController, you can `include GM::FabTabController`).
The `fab_tab_button` should be a subcalss of `UIControl`.

When you use a `FabTabView`, you must assign a `root_controller`, and its child
controllers must .  An example says it all I think:

```ruby
def viewDidLoad
  ctlr_a = CustomControllerA.new
  self.addChildViewController(ctlr_a)
  ctlr_b = CustomControllerB.new
  self.addChildViewController(ctlr_b)

  # the defaults that we take advantage of using this method:
  #   - assign the root_controller, obviously
  #   - the tab view will be sized to cover the entire view bounds of the root
  #     view controller
  self.view << FabTabView.alloc.initInRootController(self)
  # self.view << FabTabView.new(self) does the same thing
end
```

Why use a custom tab controller?  Because the built-in one does not support
custom buttons, that's the only reason.  This one is much less feature-rich, but
gets the job done!

TODO: support pressing the tab button to return to a navigation controller's
root view.

### GM::GradientView

This used to be a separate gem, but I've removed that.  It lives here now.

It's great as a background view!

TODO: implement the radial gradient.  I just haven't needed it.

### GM::TypewriterView

A `UICollectionView` can do everything that `TypewriterView` does, but with lots
more delegate methods to implement. ;-)

Add a bunch of subviews to `TypewriterView` and it will display them
left-to-right, top-to-bottom.  You can assign `scroll_view` and
`background_view` objects, too, and the `scroll_view` will get assigned the
appropriate `contentSize`, and the `background_view` will be ignored when it
lays out the subviews, and it will be sized to cover the entire view.

### GM::InsetTextField

I'm sure we've all implemented a subclass of `UITextField` that implements the
methods `placeholderRectForBounds`, `textRectForBounds`, `editingRectForBounds`

### GM::MaskedImageView

Masks a UIImageView using a UIBezierPath.  Assign an image to `image`, and a
bezier path to `path`, and that's it.

### GM::RoundedRectView

You can assign a different radius for each side.  Radius is attached to a *side*
(not per corner), so that means that there will be some symmetry.

UIViewController modules
------

These modules are all meant to enhance your custom `UIViewController` classes.

### GM::KeyboardHandler

This one is so handy!  I've tried to get it to be both simple and thorough.
Ideally, you can pass it your scroll view, and it will take care of setting the
contentInset when the keyboard is shown.  Call `keyboard_handler_start` and
`keyboard_handler_stop` like this:

```ruby
class MyController
  include GM::KeyboardHandler

  def viewWillAppear(animated)
    super
    keyboard_handler_start(@scroll_view)
  end

  def viewDidDisappear(animated)
    super
    keyboard_handler_stop(@scroll_view)
  end
end
```

### GM::Modal

coming soon

### GM::Parallax

coming soon

Tools
-----

### GM::PeoplePicker

Easy to show the address book people picker.

```ruby
GM::PeoplePicker.show { |person|
  # an ABAddressBook person will be available here, or nil if the operation was
  # canceled.
}
```

### GM::SelectOneTableViewController

This one is really handy for table-based forms.  Assign `items` and style them
with a `cell_handler` block, and an optional `include_other` boolean will
include a UITextField.  An `on_done` block is called with one of the objects in
`items` when it is selected.

