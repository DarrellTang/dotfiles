local status_ok, oatmeal = pcall(require, "oatmeal")
if not status_ok then
  return
end

oatmeal.setup ({
  backend = "ollama",
  model = "deepseek-coder:6.7b",
})
