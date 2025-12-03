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

- [ ] **UI Layout:** Design cart rows with ` [qty] + controls (min 44x44dp).
- [ ] **Model Update:** Implement Cart.updateItemQuantity(String itemId, int newQuantity).
- [ ] **Wiring:** Connect UI buttons to updateItemQuantity with optimistic updates.
- [ ] **UX - Decrement:** Handle decrement from 1 (Confirmation vs Immediate Remove).
- [ ] **UX - Feedback:** Add ripple effects/animations and disable + at max limit.
- [ ] **Error Handling:** Implement revert logic for persistence failures.
- [ ] **Testing:** Write unit tests for Cart and widget tests for interactions.
- [ ] **Accessibility:** Ensure screen reader support for buttons.

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

- [ ] **Increment:** Tapping + increases quantity by 1 and updates totals immediately.
- [ ] **Decrement:** Tapping ` decreases quantity by 1 and updates totals immediately.
- [ ] **Remove Flow:** Tapping ` at quantity 1 triggers removal flow (Confirm or Undo).
- [ ] **Max Limit:** + is disabled at quantity 99.
- [ ] **Error Revert:** UI reverts to previous value if backend update fails.
- [ ] **Undo:** Removing an item shows a Snackbar with Undo option that works.
- [ ] **A11y:** Buttons have semantic labels ("Increment quantity").
- [ ] **Perf:** Updates happen within 100ms.

---

###  Test Coverage

- [ ] **Unit:** Cart.updateItemQuantity calculates totals correctly.
- [ ] **Unit:** Cart.removeItem and RestoreRemovedItem manage list state.
- [ ] **Widget:** Tap + updates text and total.
- [ ] **Widget:** Tap ` at 1 triggers removal dialog/action.
- [ ] **Widget:** Undo restores the item.

---

###  Deliverables

- [ ] Updated Cart model.
- [ ] Updated Cart UI.
- [ ] Test suite (Unit + Widget).
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

- [ ] **UI Interaction:** Make quantity text tappable to open input dialog/sheet.
- [ ] **Input Logic:** Restrict input to digits only.
- [ ] **Validation:** Handle 0 (remove), >99 (cap), and invalid text.
- [ ] **Model Update:** Reuse Cart.updateItemQuantity.
- [ ] **Testing:** Widget tests for dialog interaction and validation.

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

- [ ] **Open Input:** Tapping quantity opens an input method.
- [ ] **Valid Update:** Entering a valid number (e.g., 5) and confirming updates the cart immediately.
- [ ] **Zero Handling:** Entering 0 prompts for removal.
- [ ] **Max Cap:** Entering 100+ either caps at 99 or shows an error.
- [ ] **Cancel:** Canceling the dialog leaves the quantity unchanged.

---

###  Test Coverage

- [ ] **Widget:** Tap quantity -> Dialog appears.
- [ ] **Widget:** Enter '5' -> Confirm -> Quantity becomes 5.
- [ ] **Widget:** Enter '0' -> Confirm -> Removal dialog appears.


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

- [ ] **UI Interaction:** Add Trash icon button and/or Swipe-to-Dismiss widget.
- [ ] **Model Update:** Implement Cart.removeItem(int itemId) and Cart.restoreRemovedItem.
- [ ] **Feedback:** Show Snackbar with "Undo" action upon removal.
- [ ] **State Management:** Ensure total price updates immediately.
- [ ] **Testing:** Widget tests for remove and undo flows.

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

- [ ] **Remove:** Tapping trash/swiping removes item from view immediately.
- [ ] **Total Update:** Cart total updates instantly.
- [ ] **Undo:** Tapping "Undo" on Snackbar restores the item and total.
- [ ] **Persistence:** Removal is saved to backend/storage.
- [ ] **Clear All:** (If implemented) "Clear Cart" asks for confirmation first.

---

###  Test Coverage

- [ ] **Unit:** RemoveItem decreases list size and total price.
- [ ] **Unit:** RestoreRemovedItem restores list size and total price.
- [ ] **Widget:** Tap Trash -> Item gone -> Snackbar visible.
- [ ] **Widget:** Tap Undo -> Item reappears.

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

- [ ] **UI Interaction:** Add "Edit" button to cart row.
- [ ] **Edit Sheet:** Create a modal/screen pre-filled with current item values.
- [ ] **Model Update:** Implement Cart.replaceItem(itemId, updatedSandwich).
- [ ] **Pricing:** Ensure price recalculates if size changes.
- [ ] **Testing:** Unit tests for replacement and pricing; Widget tests for edit flow.

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

- [ ] **Open Edit:** Tapping Edit opens a form with correct current values.
- [ ] **Save Changes:** Confirming updates the item details in the list.
- [ ] **Price Update:** Changing size updates the item price and cart total.
- [ ] **Non-Price Update:** Changing bread/type updates description but NOT price.
- [ ] **Cancel:** Canceling discards changes.

---

###  Test Coverage

- [ ] **Unit:** ReplaceItem updates sandwich details correctly.
- [ ] **Unit:** Changing size triggers price recalculation.
- [ ] **Widget:** Edit flow -> Open sheet -> Change value -> Save -> Verify UI update.
