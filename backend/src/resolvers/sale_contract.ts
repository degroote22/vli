import { SaleContractResolvers } from "../gen/resolvers";
import { ItemForSaleModel, SaleContractDb, IdentityModel } from "../db";

export const SaleContract: SaleContractResolvers = {
  seller: async (parent, args, context, info) => {
    const _seller = await IdentityModel.findById(
      (parent as SaleContractDb)._seller,
    );
    if (!_seller) {
      throw Error("Contrato sem vendedor");
    }
    return _seller;
  },
  selling: async (parent, args, context, info) => {
    const item = await ItemForSaleModel.findById(
      (parent as SaleContractDb)._selling,
    );
    if (!item) {
      throw Error("Contrato sem item de venda");
    }
    return item;
  },
};
