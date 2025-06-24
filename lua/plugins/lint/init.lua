-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 15:32:06 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 15:32:18 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  require 'lua.plugins.lint.conform',
  require 'lua.plugins.lint.lint',
  require 'lua.plugins.lint.autopairs',
  require 'lua.plugins.guess-indent',
}
