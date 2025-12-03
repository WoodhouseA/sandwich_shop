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

