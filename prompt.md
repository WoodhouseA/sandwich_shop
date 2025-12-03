# LLM Prompt — Cart Modification Features (for Sandwich Shop Flutter app)

Context:
- Models: `Sandwich` (fields: `type`, `size`, `breadType`) and `Cart` (methods: `add`, `remove`, `clear`, and a total price calculation).
- Repository: `PricingRepository` computes price based on `size` and quantity only (type and bread do not affect price).
- Pages: `Order` page (add sandwiches) and `Cart` page (view cart and total).

Please produce implementation guidance and code snippets for the following cart-editing features. For each feature include:
1. A short description of the user interaction.
2. Exactly what should happen in the UI and in the data model (Cart + Sandwich + PricingRepository).
3. Any new methods to add to `Cart` (names and signatures).
4. Edge cases, validation, and undo/feedback UX.

---

**Change Quantity (Increment / Decrement)**:
- Description: Provide `+` and `−` buttons on each cart item to change its quantity by 1.
- UI behavior:
  - Tapping `+` increases the displayed quantity immediately (optimistic update).
  - Tapping `−` decreases the displayed quantity immediately; if quantity would go below 1, show a confirmation or convert to a "remove" flow (see Remove Item).
  - Disable `+` if a sensible app limit is reached (e.g., 99).
  - Show a short animation or ripple for change and update the item subtotal and cart total instantly.
- Data/model behavior:
  - Call a new/updated cart method, e.g. `Cart.updateItemQuantity(int cartIndexOrId, int newQuantity)` which:
    - Validates `newQuantity >= 1` (unless removing is desired).
    - Updates the cart item quantity.
    - Triggers recalculation of the cart total using `PricingRepository.priceForSize(Sandwich.size) * quantity`.
    - Notifies listeners (e.g., `notifyListeners()` if using `ChangeNotifier`) to update the UI.
- Edge cases & errors:
  - If update fails (rare, e.g., persistence error), revert the UI to the previous quantity and show an error snackbar.
  - If decrement from 1: either prevent decrement below 1 or prompt removal confirmation. Specify preferred behavior to LLM.

---

**Set Quantity Directly (Edit Quantity / Input Field)**:
- Description: Tapping the quantity number opens a modal or inline numeric input to type a desired quantity.
- UI behavior:
  - Show numeric keyboard; accept only positive integers.
  - Provide confirm and cancel actions. On confirm, show optimistic update to the new value and update totals.
  - If user enters `0`, treat as "remove" and prompt the user (confirm remove).
- Data/model behavior:
  - Use `Cart.updateItemQuantity(itemId, newQuantity)` as above.
  - Validate input (`1 <= newQuantity <= MAX_QUANTITY`).
  - Recompute totals via pricing repository and update UI.
- Edge cases & validation:
  - Non-integer input: show a validation error and keep focus.
  - Very large numbers: cap at `MAX_QUANTITY` and notify the user.
  - If `newQuantity == 0`: call `Cart.removeItem(itemId)` after confirmation.

---

**Remove Item (Delete / Swipe-to-Delete / Trash Icon)**:
- Description: Allow users to remove an item via a trash icon or swipe-to-delete on the cart item row.
- UI behavior:
  - On delete, immediately remove the item from the list (optimistic) and update the cart total.
  - Display a snackbar: "Item removed" with an `Undo` action for a short window (e.g., 5–8 seconds).
  - If the user taps `Undo`, restore the item with its previous quantity.
  - For bulk clear-cart actions, show a confirmation modal before clearing.
- Data/model behavior:
  - Call `Cart.removeItem(int itemId)` which:
    - Removes the item from internal list.
    - Stores a short-lived copy of the removed item(s) for undo.
    - Recalculates the total price.
    - Emits a state update.
  - For `Undo`, call `Cart.restoreRemovedItem(removedItem)` or call `Cart.add(item, previousQuantity)` to reinsert.
- Edge cases & errors:
  - If removing fails persistently, re-add the item and show error.
  - If item removal changes aggregate discounts/totals, update those recalculations too.

---

**Edit Item Options (Change Size / Bread / Type)**:
- Description: Allow users to edit a sandwich already in their cart (e.g., change size or bread). Triggered via an `Edit` action on the cart item.
- UI behavior:
  - Present an edit sheet or navigate to a configuration screen pre-filled with the current sandwich values.
  - User updates size/bread/type and confirms.
  - On confirm, apply the change, update item display, subtotal, and cart total.
- Data/model behavior:
  - If information is mutable, create or use `Cart.replaceItem(int itemId, Sandwich updatedSandwich)` that replaces the stored sandwich object while preserving the quantity (unless user changes quantity).
  - After replacement, recompute the item unit price using `PricingRepository.priceForSize(updatedSandwich.size)` and multiply by quantity.
  - Notify UI listeners.
- Notes about pricing:
  - Since type and bread do not impact price, only changes to `size` should affect price. Make this explicit in the implementation guidance.
- Edge cases:
  - If an edit causes an item to match another existing cart item (same type, size, bread), prompt whether to merge (combine quantities) or keep as separate line items. Provide guidance preference.

---

**Batch / Multi-Select Actions (Optional)**:
- Description: Let users select multiple cart items and apply actions (increase qty, decrease qty, remove).
- UI behavior:
  - Long-press to enable multi-select, show a toolbar with actions (Remove, Increase, Decrease).
  - Confirm destructive bulk actions.
- Data/model behavior:
  - Provide batch methods like `Cart.updateBatch(Map<itemId, newQuantity>)` and `Cart.removeItems(List<itemId>)`.
- Edge cases: ensure undo supports bulk restore for the same window.

---

**Undo, Feedback & Accessibility**:
- Always provide an `Undo` affordance for destructive changes.
- Use snackbars (with `Undo`) or toasts for immediate feedback.
- Ensure control sizes are tappable and accessible; add semantic labels for screen readers on `+`, `−`, `Edit`, and `Remove`.

---

**Implementation Notes for the LLM (code-level expectations)**:
- New Cart method suggestions:
  - `void updateItemQuantity(String itemId, int newQuantity)`
  - `void removeItem(String itemId)`
  - `void replaceItem(String itemId, Sandwich updatedSandwich)`
  - `void restoreRemovedItem(CartItem removedItem)` (for Undo)
  - Optionally: `void updateBatch(Map<String, int> quantities)`
- Pricing calculation:
  - Use `final unitPrice = PricingRepository.priceForSize(updatedSandwich.size);`
  - Item subtotal = `unitPrice * quantity`
  - Cart total = sum of all item subtotals
- State management:
  - If using `ChangeNotifier` (or `Provider`), call `notifyListeners()` after mutations.
  - If using another state solution (Bloc, Riverpod), emit appropriate states.
- UI timing & optimistic updates:
  - Perform local model updates instantly, then persist to storage (or remote) in background. Revert on persistence error.
- Tests & validation:
  - Add unit tests for `Cart.updateItemQuantity`, `Cart.removeItem`, and `Cart.replaceItem` ensuring totals update correctly.
  - Add widget tests for UI interactions (tap `+`, `−`, open edit sheet, confirm removal with undo).
- Helpful example snippet (pseudo-Dart):
  ```dart
  // in Cart class
  void updateItemQuantity(String itemId, int newQuantity) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return;
    if (newQuantity <= 0) {
      removeItem(itemId); // or prompt before calling removeItem
      return;
    }
    _items[idx].quantity = newQuantity;
    _recalculateTotal();
    notifyListeners();
  }

  void removeItem(String itemId) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx == -1) return;
    final removed = _items.removeAt(idx);
    _lastRemoved = removed; // keep for undo
    _recalculateTotal();
    notifyListeners();
  }
  ```