# frozen_string_literal: true
class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_notes = site.collections['notes'].docs
    all_pages = site.pages

    all_docs = all_notes + all_pages

    link_extension = !!site.config["use_html_extension"] ? '.html' : ''

    # Convert all Wiki/Roam-style double-bracket link syntax to plain HTML
    # anchor tag elements (<a>) with "internal-link" CSS class
    all_docs.each do |current_note|
      current_note_url = current_note.url + link_extension
    
      all_docs.each do |note_potentially_linked_to|
        note_title_regexp_pattern = Regexp.escape(
          File.basename(
            note_potentially_linked_to.basename,
            File.extname(note_potentially_linked_to.basename)
          )
        ).gsub('\_', '[ _]').gsub('\-', '[ -]').capitalize
    
        title_from_data = note_potentially_linked_to.data['title']
        if title_from_data
          title_from_data = Regexp.escape(title_from_data)
        end
    
        new_href = "#{site.baseurl}#{note_potentially_linked_to.url}#{link_extension}"
    
        # 处理带有 # 和标签的链接，例如 [[title#section|label]]
        current_note.content.gsub!(
          /\[\[(#{note_title_regexp_pattern})#([^\|\]]+)\|(.+?)\]\]/i,
          "<a class='internal-link' href='#{new_href}#\\2'>\\3</a>"
        )
    
        # 处理带有 # 但没有标签的链接，例如 [[title#section]]
        current_note.content.gsub!(
          /\[\[(#{note_title_regexp_pattern})#([^\|\]]+)\]\]/i,
          "<a class='internal-link' href='#{new_href}#\\2'>\\1#\\2</a>"
        )
    
        # 处理仅有 # 和标签的链接，例如 [[#section|label]]
        current_note.content.gsub!(
          /\[\[#([^\|\]]+)\|(.+?)\]\]/i,
          "<a class='internal-link' href='#{current_note_url}#\\1'>\\2</a>"
        )
    
        # 处理仅有 # 的链接，例如 [[#section]]
        current_note.content.gsub!(
          /\[\[#([^\|\]]+)\]\]/i,
          "<a class='internal-link' href='#{current_note_url}#\\1'>\\1</a>"
        )
    
        # 处理其他格式的链接
        current_note.content.gsub!(
          /\[\[#{note_title_regexp_pattern}\|(.+?)(?=\])\]\]/i,
          "<a class='internal-link' href='#{new_href}'>\\1</a>"
        )
    
        current_note.content.gsub!(
          /\[\[#{title_from_data}\|(.+?)(?=\])\]\]/i,
          "<a class='internal-link' href='#{new_href}'>\\1</a>"
        )
    
        current_note.content.gsub!(
          /\[\[(#{title_from_data})\]\]/i,
          "<a class='internal-link' href='#{new_href}'>\\1</a>"
        )
    
        current_note.content.gsub!(
          /\[\[(#{note_title_regexp_pattern})\]\]/i,
          "<a class='internal-link' href='#{new_href}'>\\1</a>"
        )
      end
    
      # 处理无法匹配的双括号链接
      current_note.content = current_note.content.gsub(
        /\[\[([^\]]+)\]\]/i,
        <<~HTML.delete("\n")
          <span title='There is no note that matches this link.' class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span></span>
        HTML
      )
    end
  

    # Identify note backlinks and add them to each note
    all_notes.each do |current_note|
      # Nodes: Jekyll
      notes_linking_to_current_note = all_notes.filter do |e|
        e.content.include?(current_note.url)
      end

      # Nodes: Graph
      graph_nodes << {
        id: note_id_from_note(current_note),
        path: "#{site.baseurl}#{current_note.url}#{link_extension}",
        label: current_note.data['title'],
      } unless current_note.path.include?('_notes/index.html')

      # Edges: Jekyll
      current_note.data['backlinks'] = notes_linking_to_current_note

      # Edges: Graph
      notes_linking_to_current_note.each do |n|
        graph_edges << {
          source: note_id_from_note(n),
          target: note_id_from_note(current_note),
        }
      end
    end

    File.write('_includes/notes_graph.json', JSON.dump({
      edges: graph_edges,
      nodes: graph_nodes,
    }))
  end

  def note_id_from_note(note)
    note.data['title'].bytes.join
  end
end
