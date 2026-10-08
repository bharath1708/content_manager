puts "Seeding..."

categories = %w[Tutorials Tips Reviews].index_with do |name|
  Category.find_or_create_by!(name: name)
end

tags = %w[rails ruby react api beginner advanced].index_with do |name|
  Tag.find_or_create_by!(name: name)
end

contents = [
  { title: "Rails API in 10 minutes",      platform: "youtube",   content_type: "video", status: "published", category: "Tutorials", tags: %w[rails api beginner] },
  { title: "Strong params explained",      platform: "youtube",   content_type: "video", status: "published", category: "Tutorials", tags: %w[rails beginner] },
  { title: "N+1 queries in one reel",      platform: "instagram", content_type: "reel",  status: "published", category: "Tips",      tags: %w[rails advanced] },
  { title: "Ruby blocks vs Java lambdas",  platform: "instagram", content_type: "reel",  status: "draft",     category: "Tips",      tags: %w[ruby] },
  { title: "React + Rails setup",          platform: "youtube",   content_type: "video", status: "draft",     category: "Tutorials", tags: %w[react rails] },
  { title: "Best Rails books 2026",        platform: "facebook",  content_type: "post",  status: "published", category: "Reviews",   tags: %w[rails ruby] },
  { title: "Is Rails still worth it?",     platform: "facebook",  content_type: "post",  status: "archived",  category: "Reviews",   tags: %w[rails] },
  { title: "Quick tip: has_many through",  platform: "instagram", content_type: "post",  status: "published", category: nil,         tags: %w[rails advanced] }
]

contents.each do |attrs|
  content = Content.find_or_initialize_by(title: attrs[:title])
  content.update!(
    description: "Sample content: #{attrs[:title]}",
    platform: attrs[:platform],
    content_type: attrs[:content_type],
    status: attrs[:status],
    category: categories[attrs[:category]],
    tags: attrs[:tags].map { |name| tags[name] }
  )
end

puts "Done: #{Category.count} categories, #{Tag.count} tags, #{Content.count} contents"
