class PartnersDatatable
  delegate :params, :link_to, :edit_partner_path, :tag, :oauth2_prompt_partner_path, :asset_path, to: :@view

  def initialize(view, user=nil, master_filters={})
    @view = view
    @user = user
    @master_filters = master_filters
  end

  def as_json(options = {})
    {
      iTotalRecords: partners.count,
      iTotalDisplayRecords: partners.total_entries,
      data: data
    }
  end

  private

  def data 
    @partners.map do |partner|
      [
        link_to(partner.id, partner),
        link_to(partner.common_name, partner),
        partner.access_email,
        "...#{partner.oauth2_token_mark}",
        link_to('Edit', edit_partner_path(partner)) + 
        link_to(tag("img", :src=> asset_path("key.png")), oauth2_prompt_partner_path(partner), :rel =>'tooltip', :title => "Request Authentication")

      ]
    end
  end

  def partners
    @partners ||= fetch_partners
  end

  def fetch_partners 
    partners = Partner.order("#{sort_column} #{sort_direction}")
    partners = partners.where({}.merge(@master_filters)) if @master_filters.present?
    partners = partners.page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 20
  end

  def sort_column
    columns = %w[id common_name access_email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end