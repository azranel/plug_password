defmodule PlugPassword.Template.Behaviour do
  @moduledoc """
  Behaviour that should be implemented by any module that is passed as template option to PlugPassword.
  """
  @callback template() :: String.t 
end
