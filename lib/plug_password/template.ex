defmodule PlugPassword.Template do
  @behaviour PlugPassword.Template.Behaviour
  @moduledoc """
  Holds functions related to PlugPassword templates
  """

  @doc """
  Template that will be rendered for user
  """
  def template do
    """
    <!DOCTYPE html>
    <html lang="en">
      <body>
        <div class="container-fluid">
          <div class="row-fluid">
            <div class="span4"></div>
            <div class="span4">
              <legend>Sign in</legend>
              <form action="" method="post" class="form-inline">
                <input type="password" placeholder="Password..." name="password" autofocus/>
                <button type="submit" class="btn btn-primary">Sign in</button>
              </form>
            </div>
          </div>
        </div>
      </body>
    </html>
    """
  end
end
