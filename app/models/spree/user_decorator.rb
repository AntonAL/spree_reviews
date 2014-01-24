Spree::User.class_eval do
  # [FIX] Overcome issue:
  #   #<NoMethodError: undefined method `anonymous?' for #<Spree::User:0x007fe622485cc8>>
  # occured in spree_reviews-65e0b3a0baae/app/models/spree/reviews_ability.rb:7:in `block in initialize'"
  def anonymous?
    false
  end
end