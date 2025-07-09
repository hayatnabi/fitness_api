class Api::V1::FitnessPlansController < ApplicationController

  def create
    weight = params[:weight_kg].to_f
    height = params[:height_cm].to_f / 100
    bmi = (weight / (height ** 2)).round(2)

    category = case bmi
               when 0..18.4 then "Underweight"
               when 18.5..24.9 then "Normal weight"
               when 25..29.9 then "Overweight"
               else "Obese"
               end

    plan = generate_plan(params[:goal], params[:workout_type])

    render json: {
      bmi: bmi,
      bmi_category: category,
      recommendation: plan
    }
  end

  private

  def generate_plan(goal, type)
    if goal == "muscle_gain"
      {
        days_per_week: 5,
        workout_split: type == "gym" ? 
          ["Chest/Triceps", "Back/Biceps", "Legs", "Shoulders", "Cardio + Core"] :
          ["Push-ups + Dips", "Resistance Band Rows", "Squats + Lunges", "Pike Push-ups", "HIIT + Core"],
        intensity: "Moderate to High",
        notes: "Focus on compound movements and progressive overload."
      }
    elsif goal == "weight_loss"
      {
        days_per_week: 6,
        workout_split: ["Cardio", "HIIT", "Strength", "Cardio", "Mobility", "Core"],
        intensity: "High",
        notes: "Maintain calorie deficit and track progress weekly."
      }
    else
      {
        days_per_week: 4,
        workout_split: ["Full-body Strength", "Cardio", "Rest", "Yoga + Mobility", "Core"],
        intensity: "Light to Moderate",
        notes: "Consistency is key. Combine strength with mobility work."
      }
    end
  end
end