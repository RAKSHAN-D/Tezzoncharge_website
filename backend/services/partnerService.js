import Partner from '../models/Partner.js';

/**
 * Service to handle partner-related business logic and database operations
 */
export const createPartnerApplication = async (partnerData) => {
    // Business Logic: Assign initial status
    const applicationData = {
        ...partnerData,
        status: 'PENDING'
    };

    // Database Interaction
    const newPartner = await Partner.create(applicationData);

    return newPartner;
};

// Add more service functions here as needed (e.g., getPartners, updatePartnerStatus)
