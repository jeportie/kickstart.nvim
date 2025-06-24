-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 15:32:06 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 20:04:14 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  require 'lua.plugins.format.conform',
  require 'lua.plugins.format.lint',
  require 'lua.plugins.format.autopairs',
  require 'lua.plugins.format.guess-indent',
}
