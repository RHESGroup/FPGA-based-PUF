/**
  ******************************************************************************
  * File Name          : se3_sdio.c
  * Description        : SEcube MicroSD interface
  ******************************************************************************
  *
  * Copyright � 2016-present Blu5 Group <https://www.blu5group.com>
  *
  * This library is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public
  * License as published by the Free Software Foundation; either
  * version 3 of the License, or (at your option) any later version.
  *
  * This library is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  * Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
  * License along with this library; if not, see <https://www.gnu.org/licenses/>.
  *
  ******************************************************************************
  */

#include "se3_sdio.h"
//#include "usbd_storage_if.h"
#include "sdio.h"


bool secube_sdio_write(uint8_t lun, const uint8_t* buf, uint32_t blk_addr, uint16_t blk_len)
{
	if (HAL_SD_WriteBlocks_DMA(&hsd, (uint8_t *)buf, blk_addr, blk_len) == HAL_OK)
	{
		while (!secube_sdio_isready());
		return true;
	}

	return false;
}
bool secube_sdio_read(uint8_t lun, uint8_t* buf, uint32_t blk_addr, uint16_t blk_len)
{
	secube_sdio_isready();
	if (HAL_SD_ReadBlocks_DMA(&hsd, (uint8_t *)buf, blk_addr, blk_len) == HAL_OK)
	{
		while(!secube_sdio_isready());
		return true;
	}

	return false;
}

bool secube_sdio_capacity(uint32_t *block_num, uint16_t *block_size)
{

	HAL_SD_CardInfoTypeDef SDCardInfo;
	if (HAL_SD_GetCardInfo(&hsd,&SDCardInfo) == HAL_OK){
			*block_num = SDCardInfo.BlockNbr;
			*block_size = STORAGE_BLK_SIZ;
			return true;
		}

	return false;
}

bool secube_sdio_isready(void)
{

	if (HAL_SD_GetCardState(&hsd) != HAL_SD_CARD_TRANSFER)
		return false;

	return true;
}
