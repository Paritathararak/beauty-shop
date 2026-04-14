import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cart') || '[]'))

  const totalItems  = computed(() => items.value.reduce((s, i) => s + i.quantity, 0))
  const totalPrice  = computed(() => items.value.reduce((s, i) => s + i.price * i.quantity, 0))
  const shippingFee = computed(() => totalPrice.value >= 1000 ? 0 : 50)
  const grandTotal  = computed(() => totalPrice.value + shippingFee.value)

  function save() { localStorage.setItem('cart', JSON.stringify(items.value)) }

  function addItem(product, quantity = 1) {
    const existing = items.value.find(i => i.id === product.id)
    if (existing) {
      existing.quantity = Math.min(existing.quantity + quantity, product.stock)
    } else {
      items.value.push({
        id: product.id, name: product.name, image: product.image,
        price: product.sale_price ?? product.price,
        stock: product.stock, quantity
      })
    }
    save()
  }

  function updateQuantity(id, qty) {
    const item = items.value.find(i => i.id === id)
    if (item) { item.quantity = Math.max(1, Math.min(qty, item.stock)); save() }
  }

  function removeItem(id) {
    items.value = items.value.filter(i => i.id !== id); save()
  }

  function clearCart() { items.value = []; save() }

  return { items, totalItems, totalPrice, shippingFee, grandTotal, addItem, updateQuantity, removeItem, clearCart }
})
