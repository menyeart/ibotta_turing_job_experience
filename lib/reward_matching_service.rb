require 'csv'

class RewardMatchingService

  def initialize
    @queue = PurchaseEventQueue.new
    @rewards = CSV.read("./data/rewards.csv")
  end

  def create_reward_matched_event
    event = @queue.get_next_purchase_event

    purchase_event_id = event["purchase_event_id"]
    saver_id = event["saver_id"]
    product_code_id = event["product_code_id"]
    quantity = event["quantity"]

    initial_award_amount_cents = get_award_amount_cents(product_code_id)
   
    award_amount_cents = calc_total_savings(initial_award_amount_cents, quantity)

    return {
      purchase_event_id: purchase_event_id,
      saver_id: saver_id,
      award_amount_cents: award_amount_cents,
    }
  end

  def calc_total_savings(initial_cents, quantity)
    initial_cents * quantity
  end

  def get_award_amount_cents(product_code_id)
    @rewards.find { |reward| reward[0] == product_code_id.to_s }[1].to_i
  end
end