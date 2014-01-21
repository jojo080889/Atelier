# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongo_mapper and :mongoid
  config.orm = :active_record

  # Define :user_model_name. This model will be used to grand badge if no :to option is given. Default is "User".
  config.user_model_name = "User"

  # Define :current_user_method. Similar to previous option. It will be used to retrieve :user_model_name object if no :to option is given. Default is "current_#{user_model_name.downcase}".
  config.current_user_method = "current_user"
end

# Create application badges (uses https://github.com/norman/ambry)
Merit::Badge.create!({
  id: 1,
  name: 'feedback-tutorial',
  level: 1,
  description: "Completed the Beginner feedback tutorial",
  custom_fields: { skill_level: :beginner }
})
Merit::Badge.create!({
  id: 2,
  name: 'feedback-tutorial',
  level: 2,
  description: "Completed the Intermediate feedback tutorial",
  custom_fields: { skill_level: :intermediate }
})
Merit::Badge.create!({
  id: 3,
  name: 'post-project',
  level: 1,
  description: "Posted first project",
  custom_fields: { skill_level: :beginner }
})
Merit::Badge.create!({
  id: 4, 
  name: "post-project",
  level: 2,
  description: "Posted 2 projects",
  custom_fields: { skill_level: :beginner }
})
Merit::Badge.create!({
  id: 5,
  name: "post-project",
  level: 4, 
  description: "Posted 4 projects",
  custom_fields: { skill_level: :intermediate }
})
Merit::Badge.create!({
  id: 8,
  name: "rating-intermediate",
  level: 1,
  description: "Received a rating of Intermediate on one project",
  custom_fields: { skill_level: :beginner }
})
Merit::Badge.create!({
  id: 9,
  name: "rating-intermediate",
  level: 2,
  description: "Received a rating of Intermediate on two projects",
  custom_fields: { skill_level: :beginner }
})
Merit::Badge.create!({
  id: 10, 
  name: "rating-advanced",
  level: 1,
  description: "Received a rating of Advanced on one project",
  custom_fields: { skill_level: :intermediate }
})
Merit::Badge.create!({
  id: 11,
  name: "rating-advanced",
  level: 2,
  description: "Received a rating of Advanced on two projects",
  custom_fields: { skill_level: :intermediate }
})


# Merit::Badge.create!({
#   id: 1,
#   name: 'just-registered'
# }, {
#   id: 2,
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# })
