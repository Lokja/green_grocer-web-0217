require "pry"

def consolidate_cart(cart)
  output = {}
  foods = []
  cart.each do |item|
    item.each do |food, data|
      output[food] = data
      foods << food
      output[food][:count] = foods.count(food)
    end
  end
  output
end

def apply_coupons(cart, coupons)
  coupons.each do |data|
    name = data[:item]
    if cart[name] && cart[name][:count] >= data[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => data[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= data[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  discount = 0.80
  cart.each do |food, datah|
    if datah[:clearance]
      cart[food][:price] = (cart[food][:price]*discount).round(3)
    end
  end
  cart
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(cons_cart, coupons)
  last_cart = apply_clearance(coup_cart)
  total = 0
  last_cart.each do |food, datah|
    total += datah[:price]*datah[:count]
  end
  if total > 100
    total = total*0.9
  end
  total.round(2)
end
