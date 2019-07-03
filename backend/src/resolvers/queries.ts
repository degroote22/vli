import { QueryResolvers, Identity } from "../gen/resolvers";
import { IdentityModel, IdentityDb, AccountModel } from "../db";
import { Types } from "mongoose";

export const Query: QueryResolvers<{}> = {
  identityById: async (_parent, args, context, info) => {
    if (!Types.ObjectId.isValid(args.id)) {
      throw Error("Id inválido! Use um ID válido do mongoose.");
    }
    return await IdentityModel.findById(args.id);
  },
  accountById: async (_parent, args, context, info) => {
    if (!Types.ObjectId.isValid(args.id)) {
      throw Error("Id inválido! Use um ID válido do mongoose.");
    }
    return await AccountModel.findById(args.id);
  },
};
