module PagyHelper
  include Pagy::Frontend

  def pagy_bootstrap_nav_with_first_last(pagy)
    nav, _ = pagy_bootstrap_nav(pagy)

    first_button =
      if pagy.page > 1
        link_to i18n(:begin).capitalize,
                pagy_url_for(pagy, 1),
                class: "page-link"
      end

    last_button =
      if pagy.page < pagy.last
        link_to i18n(:end).capitalize,
                pagy_url_for(pagy, pagy.last),
                class: "page-link"
      end

    <<~HTML
      <nav class="pagy-bootstrap-nav">
        <ul class="pagination">
          <li class="page-item">#{first_button}</li>
          #{nav}
          <li class="page-item">#{last_button}</li>
        </ul>
      </nav>
    HTML
  end
end
