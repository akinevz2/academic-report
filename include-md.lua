local included_files = {}
local path_sep = package.config:sub(1,1)

local function is_absolute_path(path)
  return path:match("^/") or path:match("^%a:[/\\]") or path:match("^\\\\")
end

local function normalize_path(path)
  local prefix = ""

  if path:match("^%a:[/\\]") then
    prefix = path:sub(1, 2)
    path = path:sub(3)
  elseif path:match("^\\\\") then
    prefix = "\\\\"
    path = path:gsub("^\\\\", "")
  elseif path:match("^/") then
    prefix = path_sep
    path = path:gsub("^/+", "")
  end

  local parts = {}
  for part in path:gmatch("[^/\\]+") do
    if part == ".." then
      if #parts > 0 and parts[#parts] ~= ".." then
        table.remove(parts)
      elseif prefix == "" then
        table.insert(parts, part)
      end
    elseif part ~= "." and part ~= "" then
      table.insert(parts, part)
    end
  end

  local normalized = table.concat(parts, path_sep)
  if prefix == "\\\\" then
    return prefix .. normalized
  end
  if prefix ~= "" then
    if normalized == "" then
      return prefix
    end
    if prefix == path_sep then
      return prefix .. normalized
    end
    return prefix .. path_sep .. normalized
  end
  return normalized ~= "" and normalized or "."
end

local function get_dirname(path)
  return path:match("^(.*)[/\\]") or "."
end

local function make_absolute(path)
  if is_absolute_path(path) then
    return normalize_path(path)
  end
  return normalize_path((os.getenv("PWD") or ".") .. path_sep .. path)
end

local function resolve_path(base, relative)
  if is_absolute_path(relative) then
    return normalize_path(relative)
  end
  return normalize_path(base .. path_sep .. relative)
end

local function include_markdown_file(source_path)
  local full_path = make_absolute(source_path)

  if included_files[full_path] then
    return { pandoc.Para({ pandoc.Str("Circular include prevented: " .. full_path) }) }
  end

  included_files[full_path] = true

  local file = io.open(full_path, "r")
  if not file then
    return { pandoc.Para({ pandoc.Str("Could not read file: " .. full_path) }) }
  end

  local content = file:read("*all")
  file:close()

  local base_dir = get_dirname(full_path)

  local parsed = pandoc.read(content, "markdown", PANDOC_OPTIONS)

  -- Extract .md links from a list of inlines, returning included blocks and remaining inlines
  local function process_inlines(inlines)
    local result_blocks = {}
    local new_inlines = {}

    for _, inline in ipairs(inlines) do
      if inline.t == "Link" and inline.target:match("%.md$") and not inline.target:match("^https?://") then
        local linked_path = resolve_path(base_dir, inline.target)
        local included = include_markdown_file(linked_path)
        for _, blk in ipairs(included) do
          table.insert(result_blocks, blk)
        end
      else
        table.insert(new_inlines, inline)
      end
    end

    return result_blocks, new_inlines
  end

  -- Process Para blocks (direct links in paragraphs)
  local function process_para(para)
    local result_blocks, new_inlines = process_inlines(para.content)

    if #new_inlines > 0 then
      table.insert(result_blocks, pandoc.Para(new_inlines))
    end

    return result_blocks
  end

  -- Process BulletList blocks (links inside list items)
  local function process_bulletlist(bl)
    local result_blocks = {}

    for _, item in ipairs(bl.content) do
      for _, block in ipairs(item) do
        if block.t == "Plain" or block.t == "Para" then
          local included, remaining = process_inlines(block.content)
          for _, blk in ipairs(included) do
            table.insert(result_blocks, blk)
          end
          -- Keep any non-link text
          if #remaining > 0 then
            table.insert(result_blocks, pandoc.Para(remaining))
          end
        else
          table.insert(result_blocks, block)
        end
      end
    end

    return result_blocks
  end

  return pandoc.walk_block(pandoc.Div(parsed.blocks), {
    Para = process_para,
    BulletList = process_bulletlist
  }).content
end

-- Entry point for the filter
return {
  {
    Pandoc = function(doc)
      local meta_path = PANDOC_STATE.input_files and PANDOC_STATE.input_files[1]
      if not meta_path then
        io.stderr:write("Could not determine source file path.\n")
        return doc
      end
      local blocks = include_markdown_file(meta_path)
      return pandoc.Pandoc(blocks, doc.meta)
    end
  }
}
