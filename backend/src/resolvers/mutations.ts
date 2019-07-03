import { MutationResolvers, Identity } from "../gen/resolvers";
import {
  IdentityModel,
  ItemForSaleModel,
  AccountModel,
  SaleContractModel,
  SalePutHistoryModel,
  SaleRemoveHistoryModel,
} from "../db";
import { Types } from "mongoose";
import * as bcrypt from "bcrypt";
import * as jwt from "jsonwebtoken";
import { BackContext } from "../types";
import { JWT_SECRET } from "../constants";

const _hash = (password: string): Promise<String> => {
  return bcrypt.hash(password, 10);
};
const _compare = (password: string, hash: string): Promise<boolean> => {
  return bcrypt.compare(password, hash);
};

export const Mutation: MutationResolvers<BackContext> = {
  authenticateAccount: async (parent, args, context, info) => {
    const acc = await AccountModel.findOne({ email: args.email });
    if (!acc) {
      throw Error("Nenhuma conta encontrada com este e-mail.");
    }
    // const hash = await _hash(args.password);
    if (!_compare(args.password, acc.hash)) {
      throw Error("Senha incorreta.");
    }
    const token = jwt.sign({ id: acc._id, role: "account" }, JWT_SECRET, {
      expiresIn: "30 days",
    });

    return token;
  },
  addSaleRemoveHistory: async (parent, args, context, info) => {
    if (context.role !== "identity") {
      throw Error("Somente identidades registram vendas");
    }

    const contract = await SaleContractModel.findById(args.input.contractId);
    if (!contract) {
      throw Error("Não há contrato com este id");
    }

    if (context.userId !== (contract as any)._seller) {
      throw Error("Usuário não é dono do contrato");
    }

    // TODO verificar q o usuário é o dono

    let inThisContract = false;
    contract.history.forEach(h => {
      if (h._id === args.input.removedId) {
        inThisContract = true;
      }
    });
    if (!inThisContract) {
      throw Error("Tentando remover item que não existe no contrato");
    }

    const action = await SaleRemoveHistoryModel.create({
      _id: new Types.ObjectId() as any,
      _when: args.input.when || new Date(), // TODO: remover
      userGeneratedId: args.input.userGeneratedId,
      removedId: args.input.removedId,
      type: "delete",
    });
    contract.history.push(action);
    await contract.save();

    return action;
  },
  addSalePutHistory: async (parent, args, context, info) => {
    if (context.role !== "identity") {
      throw Error("Somente identidades registram vendas");
    }

    const contract = await SaleContractModel.findById(args.input.contractId);
    if (!contract) {
      throw Error("Não há contrato com este id");
    }

    if (context.userId !== (contract as any)._seller) {
      throw Error("Usuário não é dono do contrato");
    }

    const action = await SalePutHistoryModel.create({
      _id: new Types.ObjectId() as any,
      _when: args.input.when || new Date(), // TODO: remover
      userGeneratedId: args.input.userGeneratedId,
      ammount: args.input.ammount,
      latitude: args.input.latitude,
      longitude: args.input.longitude,
      type: "put",
    });
    contract.history.push(action);
    await contract.save();

    return action;
  },
  registerContractToIdentity: async (parent, args, context, info) => {
    if (context.role !== "account") {
      throw Error("Só contas completas podem registrar contratos");
    }
    if (!Types.ObjectId.isValid(args.input.identityId)) {
      throw Error(
        "Id inválido para a identidade! Use um ID válido do mongoose.",
      );
    }
    const identity = await IdentityModel.findById(args.input.identityId);

    if (!identity) {
      throw Error("Não foi possível encontrar identidade com este id!");
    }
    if (context.userId != (identity._owner as any)) {
      throw Error("Usuário diferente do dono da identidade");
    }
    const selling = await ItemForSaleModel.findById(
      args.input.contract.sellingId,
    );
    if (!selling) {
      throw Error("Item para vender não existe");
    }
    const contract = await SaleContractModel.create({
      _id: new Types.ObjectId() as any,
      _selling: selling._id,
      _seller: identity._id,
      ammount: args.input.contract.ammount,
    });
    identity.contracts.push(contract);

    await identity.save();

    selling._contracts.push(contract._id);

    await selling.save();

    return identity;
  },
  registerAccount: async (parent, args, context, info) => {
    const acc = await AccountModel.findOne({ email: args.input.email });
    if (acc) {
      throw Error("Conta com este e-mail já cadastrada.");
    }
    return await AccountModel.create({
      _id: new Types.ObjectId() as any,
      name: args.input.name,
      email: args.input.email,
      hash: await _hash(args.input.password),
    });
  },
  registerIdentity: async (parent, args, context, info) => {
    if (context.role !== "account") {
      throw Error("Só contas completas podem registrar identidade");
    }

    // TODO descobre o id do dono
    const account = await AccountModel.findById(context.userId);

    if (!account) {
      throw Error("Não foi possível encontrar a conta registrada.");
    }

    const identity = await IdentityModel.create({
      _id: new Types.ObjectId() as any,
      name: args.input.name,
      sellerName: args.input.sellerName,
      _owner: context.userId,
    });

    account._identities.push(identity._id);
    await account.save();

    return identity;
  },
  registerItem: async (parent, args, context, info) => {
    if (context.role !== "account") {
      throw Error("Só contas completas podem registrar itens");
    }
    const account = await AccountModel.findById(context.userId);
    if (!account) {
      throw Error("Não foi possível encontrar a conta registrada.");
    }
    const item = await ItemForSaleModel.create({
      _id: new Types.ObjectId() as any,
      name: args.input.name,
      price: args.input.price,
      _owner: context.userId,
    });

    account._items.push(item._id);
    await account.save();

    return item;
  },
};
