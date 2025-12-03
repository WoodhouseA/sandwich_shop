#  Sandwich Shop App - Requirements

##  Feature: Change Quantity (Increment / Decrement)

###  Overview
**Purpose:** Allow users to increment or decrement the quantity of each sandwich in their cart using clearly labeled + and ` controls.
**Goal:** Immediate UI feedback, correct price recalculation, and safe handling of edge cases.

###  Definitions & Assumptions
*   **Cart Item ID:** Unique String itemId.
*   **Quantity:** 1 to MAX_QUANTITY (99).
*   **Pricing:** PricingRepository.priceForSize(size) * quantity.

---

###  Implementation Tasks

- [x] **UI Layout:** Design cart rows with ` [qty] + controls (min 44x44dp).
- [x] **Model Update:** Implement Cart.updateItemQuantity(String itemId, int newQuantity).
- [x] **Wiring:** Connect UI buttons to updateItemQuantity with optimistic updates.
- [x] **UX - Decrement:** Handle decrement from 1 (Confirmation vs Immediate Remove).
- [x] **UX - Feedback:** Add ripple effects/animations and disable + at max limit.
- [x] **Error Handling:** Implement revert logic for persistence failures.
- [x] **Testing:** Write unit tests for Cart and widget tests for interactions.
- [x] **Accessibility:** Ensure screen reader support for buttons.

---

###  User Stories

*   **US-1:** As a shopper, I want to tap + to increase quantity.
*   **US-2:** As a shopper, I want to tap ` to decrease quantity.
*   **US-3:** As a shopper, I cannot exceed the maximum quantity limit.
*   **US-4:** As a shopper, I am warned or protected when decrementing below 1.
*   **US-5:** As a shopper, I see immediate price updates.
*   **US-6:** As a shopper, I can undo an accidental removal.

---

###  Detailed Requirements

#### UI Controls
*   Display quantity between ` and +.
*   Disable + when quantity >= 99.
*   Visual feedback on tap.

#### Data / Model
*   updateItemQuantity(itemId, newQuantity):
*   Validate range [1, 99].
*   Recalculate subtotal & total.
*   Notify listeners.
*   RemoveItem(itemId) & RestoreRemovedItem(item) for Undo.

#### Edge Cases
*   **Decrement from 1:** Prompt confirmation OR remove immediately (Decision needed).
*   **Persistence Fail:** Revert UI and show Snackbar.
*   **Merge:** If editing creates duplicate items, merge quantities.

---

###  Acceptance Criteria

- [x] **Increment:** Tapping + increases quantity by 1 and updates totals immediately.
- [x] **Decrement:** Tapping ` decreases quantity by 1 and updates totals immediately.
- [x] **Remove Flow:** Tapping ` at quantity 1 triggers removal flow (Confirm or Undo).
- [x] **Max Limit:** + is disabled at quantity 99.
- [x] **Error Revert:** UI reverts to previous value if backend update fails.
- [x] **Undo:** Removing an item shows a Snackbar with Undo option that works.
- [x] **A11y:** Buttons have semantic labels ("Increment quantity").
- [x] **Perf:** Updates happen within 100ms.

---

###  Test Coverage

- [x] **Unit:** Cart.updateItemQuantity calculates totals correctly.
- [x] **Unit:** Cart.removeItem and RestoreRemovedItem manage list state.
- [x] **Widget:** Tap + updates text and total.
- [x] **Widget:** Tap ` at 1 triggers removal dialog/action.
- [x] **Widget:** Undo restores the item.

---

###  Deliverables

- [x] Updated Cart model.
- [x] Updated Cart UI.
- [x] Test suite (Unit + Widget).
- [ ] Documentation/README update.


##  Feature: Set Quantity Directly (Edit Quantity)

###  Overview
**Purpose:** Allow users to tap the quantity number to open a modal or inline input for typing a specific quantity.
**Goal:** Enable quick entry for large quantity changes and precise control.

###  Definitions & Assumptions
*   **Input:** Numeric keyboard, positive integers only.
*   **Validation:** 1 to MAX_QUANTITY (99).
*   **Zero Input:** Treated as a removal request.

---

###  Implementation Tasks

- [x] **UI Interaction:** Make quantity text tappable to open input dialog/sheet.
- [x] **Input Logic:** Restrict input to digits only.
- [x] **Validation:** Handle 0 (remove), >99 (cap), and invalid text.
- [x] **Model Update:** Reuse Cart.updateItemQuantity.
- [x] **Testing:** Widget tests for dialog interaction and validation.

---

###  User Stories

*   **US-7:** As a shopper, I want to type a quantity directly so I don't have to tap + many times.
*   **US-8:** As a shopper, I want to be prevented from entering invalid numbers (negative, non-numeric).
*   **US-9:** As a shopper, if I enter 0, I want to be asked if I want to remove the item.

---

###  Detailed Requirements

#### UI Controls
*   Tapping the quantity number opens a dialog/bottom sheet.
*   Numeric keyboard is shown by default.
*   "Cancel" and "Confirm" actions.

#### Data / Model
*   Reuse Cart.updateItemQuantity(itemId, newQuantity).
*   **Validation:**
    *   If input is not a number -> Show error / keep focus.
    *   If input > MAX_QUANTITY -> Cap at max or show error.
    *   If input == 0 -> Trigger removal flow (confirm dialog).

#### Edge Cases
*   **Empty Input:** Treat as "Cancel" or show validation error.
*   **Paste:** Prevent pasting non-numeric text.

---

###  Acceptance Criteria

- [x] **Open Input:** Tapping quantity opens an input method.
- [x] **Valid Update:** Entering a valid number (e.g., 5) and confirming updates the cart immediately.
- [x] **Zero Handling:** Entering 0 prompts for removal.
- [x] **Max Cap:** Entering 100+ either caps at 99 or shows an error.
- [x] **Cancel:** Canceling the dialog leaves the quantity unchanged.

---

###  Test Coverage

- [x] **Widget:** Tap quantity -> Dialog appears.
- [x] **Widget:** Enter '5' -> Confirm -> Quantity becomes 5.
- [x] **Widget:** Enter '0' -> Confirm -> Removal dialog appears.


##  Feature: Remove Item (Delete / Swipe-to-Delete)

###  Overview
**Purpose:** Allow users to remove an item via a trash icon or swipe-to-delete on the cart item row.
**Goal:** Provide a quick way to remove items with safety mechanisms (Undo).

###  Definitions & Assumptions
*   **Optimistic Removal:** Item disappears immediately.
*   **Undo Window:** 5-8 seconds via Snackbar.
*   **Bulk Clear:** Requires confirmation modal.

---

###  Implementation Tasks

- [x] **UI Interaction:** Add Trash icon button and/or Swipe-to-Dismiss widget.
- [x] **Model Update:** Implement Cart.removeItem(int itemId) and Cart.restoreRemovedItem.
- [x] **Feedback:** Show Snackbar with "Undo" action upon removal.
- [x] **State Management:** Ensure total price updates immediately.
- [x] **Testing:** Widget tests for remove and undo flows.

---

###  User Stories

*   **US-10:** As a shopper, I want to easily remove an item I no longer want.
*   **US-11:** As a shopper, if I delete an item by mistake, I want to undo it quickly.
*   **US-12:** As a shopper, I want to see the total price drop immediately when I remove an item.

---

###  Detailed Requirements

#### UI Controls
*   **Trash Icon:** Explicit button on the row.
*   **Swipe:** (Optional) Standard swipe-to-delete gesture.
*   **Snackbar:** "Item removed" message with "Undo" button.

#### Data / Model
*   Cart.removeItem(itemId):
    *   Remove from list.
    *   Store copy for Undo.
    *   Recalculate total.
    *   Notify listeners.
*   Cart.restoreRemovedItem(item):
    *   Add item back at previous index (or end).
    *   Recalculate total.

#### Edge Cases
*   **Rapid Delete:** Deleting multiple items quickly -> Queue snackbars or handle multiple undos (simplify to last item if needed).
*   **Empty Cart:** Removing last item shows empty state.

---

###  Acceptance Criteria

- [x] **Remove:** Tapping trash/swiping removes item from view immediately.
- [x] **Total Update:** Cart total updates instantly.
- [x] **Undo:** Tapping "Undo" on Snackbar restores the item and total.
- [x] **Persistence:** Removal is saved to backend/storage.
- [ ] **Clear All:** (If implemented) "Clear Cart" asks for confirmation first.

---

###  Test Coverage

- [x] **Unit:** RemoveItem decreases list size and total price.
- [x] **Unit:** RestoreRemovedItem restores list size and total price.
- [x] **Widget:** Tap Trash -> Item gone -> Snackbar visible.
- [x] **Widget:** Tap Undo -> Item reappears.

##  Feature: Edit Item Options (Size / Bread / Type)

###  Overview
**Purpose:** Allow users to modify the properties (size, bread, type) of a sandwich already in the cart.
**Goal:** Enable corrections or changes without removing and re-adding items.

###  Definitions & Assumptions
*   **Mutable Fields:** Size, Bread, Type.
*   **Pricing Impact:** Only Size affects unit price.
*   **Merge Logic:** If editing makes an item identical to another, prompt to merge or keep separate.

---

###  Implementation Tasks

- [x] **UI Interaction:** Add "Edit" button to cart row.
- [x] **Edit Sheet:** Create a modal/screen pre-filled with current item values.
- [x] **Model Update:** Implement Cart.replaceItem(itemId, updatedSandwich).
- [x] **Pricing:** Ensure price recalculates if size changes.
- [x] **Testing:** Unit tests for replacement and pricing; Widget tests for edit flow.

---

###  User Stories

*   **US-13:** As a shopper, I want to change the size of a sandwich in my cart.
*   **US-14:** As a shopper, I want to switch the bread type without starting over.
*   **US-15:** As a shopper, I expect the price to update if I change the size.

---

###  Detailed Requirements

#### UI Controls
*   **Edit Button:** Text or Icon button on the cart item.
*   **Edit Screen/Sheet:**
    *   Dropdowns/Selectors for Size, Bread, Type.
    *   "Cancel" and "Save Changes" buttons.
    *   Pre-selected values match the item being edited.

#### Data / Model
*   Cart.replaceItem(itemId, updatedSandwich):
    *   Find item by ID.
    *   Update the Sandwich object.
    *   Recalculate unit price: PricingRepository.priceForSize(updatedSandwich.size).
    *   Recalculate subtotal (unitPrice * quantity) and cart total.
    *   Notify listeners.

#### Edge Cases
*   **Merge Conflict:** If the updated item matches another existing item -> Prompt user: "Merge with existing item?"
    *   **Yes:** Add quantities, remove old item.
    *   **No:** Keep as separate line item.
*   **No Changes:** Saving without changes closes the sheet with no action.

---

###  Acceptance Criteria

- [x] **Open Edit:** Tapping Edit opens a form with correct current values.
- [x] **Save Changes:** Confirming updates the item details in the list.
- [x] **Price Update:** Changing size updates the item price and cart total.
- [x] **Non-Price Update:** Changing bread/type updates description but NOT price.
- [x] **Cancel:** Canceling discards changes.

---

###  Test Coverage

- [x] **Unit:** ReplaceItem updates sandwich details correctly.
- [x] **Unit:** Changing size triggers price recalculation.
- [x] **Widget:** Edit flow -> Open sheet -> Change value -> Save -> Verify UI update.

##  Feature: Batch / Multi-Select Actions (Optional)

###  Overview
**Purpose:** Allow users to select multiple cart items and apply actions (remove, etc.) in bulk.
**Goal:** Improve efficiency for managing large orders.

###  Definitions & Assumptions
*   **Trigger:** Long-press on an item enters selection mode.
*   **Toolbar:** Appears when items are selected, replacing the app bar or floating.

---

###  Implementation Tasks

- [ ] **UI Interaction:** Implement long-press gesture and selection state.
- [ ] **Selection Mode:** Show checkboxes or visual highlight for selected items.
- [ ] **Toolbar:** Create action bar with "Remove" (and optionally +/-).
- [ ] **Model Update:** Implement Cart.removeItems(List<itemId>).
- [ ] **Testing:** Widget tests for selection and bulk removal.

---

###  User Stories

*   **US-16:** As a shopper, I want to select multiple items to remove them all at once.
*   **US-17:** As a shopper, I want to clearly see which items are selected.

---

###  Detailed Requirements

#### UI Controls
*   **Long-Press:** Enters multi-select mode.
*   **Checkboxes:** Appear on left/right of items.
*   **Context Bar:** Shows "X items selected" and action buttons (Trash).
*   **Cancel:** Back button or "Cancel" exits selection mode.

#### Data / Model
*   Cart.removeItems(List<String> itemIds):
    *   Remove all specified items.
    *   Store list of removed items for Undo (Bulk Undo).
    *   Recalculate total.

#### Edge Cases
*   **Select All:** Optional "Select All" button.
*   **Empty Selection:** Toolbar actions disabled if 0 items selected.

---

###  Acceptance Criteria

- [ ] **Enter Mode:** Long-press changes UI to selection mode.
- [ ] **Select:** Tapping items toggles selection.
- [ ] **Bulk Remove:** Tapping Trash removes all selected items.
- [ ] **Bulk Undo:** Undo restores all removed items.

---

###  Test Coverage

- [ ] **Unit:** RemoveItems handles list of IDs correctly.
- [ ] **Widget:** Long-press -> Select 2 items -> Remove -> Verify both gone.

---

##  Feature: Undo, Feedback & Accessibility

###  Overview
**Purpose:** Ensure the app is safe to use (undo) and accessible to all users (screen readers, touch targets).
**Goal:** Compliance with accessibility standards and good UX practices.

###  Definitions & Assumptions
*   **Touch Target:** Minimum 44x44dp.
*   **Semantics:** All icon-only buttons must have labels.

---

###  Implementation Tasks

- [x] **Undo:** Ensure all destructive actions have an Undo path.
- [x] **Feedback:** Use Snackbars/Toasts for confirmation.
- [x] **A11y Labels:** Add semanticLabel to IconButtons.
- [x] **Focus Order:** Ensure logical traversal for keyboard/screen readers.

---

###  User Stories

*   **US-18:** As a user with low vision, I want my screen reader to tell me what the "Trash" icon does.
*   **US-19:** As a user with motor impairments, I need buttons to be large enough to tap easily.
*   **US-20:** As a user, I want confirmation when I perform a major action.

---

###  Detailed Requirements

#### Accessibility (A11y)
*   **Labels:**
    *   + -> "Increment quantity for [Sandwich Name]"
    *   ` -> "Decrement quantity for [Sandwich Name]"
    *   Trash -> "Remove [Sandwich Name] from cart"
*   **Sizing:** Ensure IconButton or custom widgets have min 44dp hit area.

#### Feedback
*   **Snackbars:** "Item removed", "Quantity updated" (optional for screen readers).
*   **Haptics:** (Optional) Light vibration on quantity change.

---

###  Acceptance Criteria

- [x] **Semantics:** Screen reader announces button functions clearly.
- [x] **Hit Test:** Buttons are easy to tap (no mis-taps).
- [x] **Undo Consistency:** Undo is available for single and bulk removals.

---

###  Test Coverage

- [x] **A11y Test:** Verify semantic nodes in widget tree.
- [x] **Manual:** Test with TalkBack/VoiceOver (if possible) or SemanticsDebugger.

##  Feature: Sign In / Sign Up Page

###  Overview
**Purpose:** Provide a user-friendly entry point for users to access the app.
**Goal:** Create the UI for authentication with clear feedback and smooth transitions between modes (Logic is mocked).

###  Definitions & Assumptions
*   **Auth Logic:** No real backend; successful login is simulated.
*   **Valid Email:** Standard email regex format.
*   **Valid Password:** Minimum 6 characters.

---

###  Implementation Tasks

- [x] **UI Layout:** Create AuthScreen with centered layout, text fields, and action buttons.
- [x] **State Management:** Manage form state (email, password, confirm password, mode: sign-in/sign-up, loading status).
- [x] **Auth Simulation:** Simulate a network delay before navigating (no real auth service needed).
- [x] **Validation:** Implement form validation for email format and password length/matching.
- [x] **Navigation:** Route to OrderScreen on success.
- [x] **Feedback:** Show loading indicators during processing.
- [x] **Testing:** Widget tests for UI switching and interaction.

---

###  User Stories

*   **US-21:** As a user, I want to sign in with my email and password to access the app.
*   **US-22:** As a new user, I want to create an account so I can start ordering.
*   **US-23:** As a user, I want to see clear error messages if I enter invalid details.
*   **US-24:** As a user, I want to easily switch between signing in and signing up.

---

###  Detailed Requirements

#### UI Controls
*   **Email TextField:** KeyboardType.emailAddress.
*   **Password TextField:** ObscureText enabled.
*   **Confirm Password TextField:** Only visible in Sign Up mode.
*   **Primary Action Button:** Label changes based on mode ("Sign In" or "Sign Up").
*   **Toggle Button:** Text button to switch modes (e.g., "Need an account? Sign Up").
*   **Loading Indicator:** Replaces button text or disables button when processing.

#### Data / Model
*   **No Actual Authentication:** The "Sign In" and "Sign Up" buttons should simulate a delay (e.g., 1 second) and then navigate to the Order Screen.
*   **Validation Logic:**
    *   Email: Not empty, valid regex.
    *   Password: Min 6 chars.
    *   Confirm Password: Must match Password (Sign Up only).

#### Edge Cases
*   **Empty Fields:** Disable button or show inline errors.

---

###  Acceptance Criteria

- [x] **Mode Switch:** Tapping the toggle switches between Sign In and Sign Up forms.
- [x] **Validation:** Invalid email or short password prevents submission and shows error.
- [x] **Password Match:** Sign Up fails if passwords do not match.
- [x] **Success:** Valid inputs navigate to the Order Screen after a simulated delay.
- [x] **Loading:** Button shows loading spinner during async operation.

---

###  Test Coverage

- [x] **Unit:** Validation logic correctly identifies valid/invalid inputs.
- [x] **Widget:** Switching modes shows/hides Confirm Password field.
- [x] **Widget:** Tapping button triggers loading state.

##  Feature: Navigation & Responsive Design

###  Overview
**Purpose:** Provide consistent and accessible navigation across all screens, adapting to different screen sizes.
**Goal:** Implement a Navigation Drawer for mobile and a permanent sidebar/rail for larger screens.

###  Definitions & Assumptions
*   **Mobile Breakpoint:** < 600 logical pixels.
*   **Desktop/Tablet:** >= 600 logical pixels.
*   **Destinations:** Order (Home), Cart, About, Sign In/Up.

---

###  Implementation Tasks

- [ ] **Component:** Create a reusable `AppDrawer` widget with navigation links.
- [ ] **Responsive Layout:** Create a `ResponsiveScaffold` widget that switches between a modal Drawer (mobile) and permanent Sidebar (desktop).
- [ ] **Integration:** Refactor existing screens (`OrderScreen`, `CartScreen`, `AboutScreen`, `AuthScreen`) to use `ResponsiveScaffold`.
- [ ] **State:** Ensure the active route is highlighted in the navigation.
- [ ] **Testing:** Widget tests for drawer opening, navigation, and responsive layout changes.

---

###  User Stories

*   **US-25:** As a user, I want to access the menu from any screen.
*   **US-26:** As a user on a phone, I want a slide-out drawer to save screen space.
*   **US-27:** As a user on a tablet/desktop, I want the menu always visible for faster navigation.

---

###  Acceptance Criteria

- [ ] **Drawer:** Hamburger menu appears on mobile; tapping it opens the drawer.
- [ ] **Sidebar:** Menu is permanently visible on screens wider than 600px.
- [ ] **Navigation:** Tapping a link navigates to the correct screen.
- [ ] **Highlight:** The current screen is visually highlighted in the menu.

---

###  Test Coverage

- [ ] **Widget:** Verify Drawer opens on mobile.
- [ ] **Widget:** Verify Sidebar exists on desktop.
- [ ] **Widget:** Verify navigation links work.
